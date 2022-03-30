# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2022, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************************

# frozen_string_literal: true

class Validator
  def self.run_validators(hpxml_doc, stron_paths, include_id: true)
    errors = []
    warnings = []

    context_elements_cache = {}
    stron_paths.each do |stron_path|
      error, warning = run_validator(hpxml_doc, stron_path, context_elements_cache, include_id)
      errors += error
      warnings += warning
    end

    return errors.uniq, warnings.uniq
  end

  private

  def self.run_validator(hpxml_doc, stron_path, context_elements_cache, include_id)
    errors = []
    warnings = []

    doc = XMLHelper.parse_file(stron_path)
    XMLHelper.get_elements(doc, '/sch:schema/sch:pattern/sch:rule').each do |rule|
      context_xpath = XMLHelper.get_attribute_value(rule, 'context').gsub('h:', '')

      context_elements = get_context_elements(hpxml_doc, context_xpath, context_elements_cache)
      next if context_elements.empty? # Skip if context element doesn't exist

      ['sch:assert', 'sch:report'].each do |element_name|
        elements = XMLHelper.get_elements(rule, element_name)
        elements.each do |element|
          test_attr = XMLHelper.get_attribute_value(element, 'test').gsub('h:', '')

          context_elements.each do |context_element|
            begin
              xpath_result = context_element.xpath(test_attr)
            rescue
              fail "Invalid xpath: #{test_attr}"
            end

            next unless (element_name == 'sch:assert' && !xpath_result) || (element_name == 'sch:report' && xpath_result)

            # Try to retrieve ID (and associated element) for the context element
            if include_id
              sys_id = XMLHelper.get_attribute_value(XMLHelper.get_element(context_element, 'SystemIdentifier'), 'id')
              if sys_id.nil?
                # Keep checking parent elements
                context_element.each_ancestor do |parent_element|
                  sys_id = XMLHelper.get_attribute_value(XMLHelper.get_element(parent_element, 'SystemIdentifier'), 'id')
                  break unless sys_id.nil?
                end
              end
              sys_id_string = ", id: \"#{sys_id}\"" unless sys_id.nil?
            end

            message = "#{element.children.text} [context: #{context_xpath}#{sys_id_string}]"
            if element_name == 'sch:assert'
              errors << message
            elsif element_name == 'sch:report'
              warnings << message
            end
          end
        end
      end
    end

    return errors, warnings
  end

  def self.get_context_elements(hpxml_doc, context_xpath, context_elements_cache)
    # Returns all XML elements that match context_xpath.
    # This method is used to incorporate performance improvements by
    # attempting to avoid expensive xpath() calls when possible.

    # Check if context_xpath already queried
    context_elements = context_elements_cache[context_xpath]
    return context_elements unless context_elements.nil?

    # Check if a parent xpath already found to have no element matches
    parent_is_empty = false
    context_elements_cache.each do |k, v|
      next unless context_xpath.include? k
      next unless v.empty?

      parent_is_empty = true
      break
    end
    if parent_is_empty
      # If a parent xpath had no element matches, then context_xpath must
      # also have no element matches. So return an empty list to skip the
      # xpath query.
      context_elements_cache[context_xpath] = []
      return context_elements_cache[context_xpath]
    end

    # If we got this far, we must proceed with the xpath query.
    begin
      context_elements_cache[context_xpath] = hpxml_doc.xpath(context_xpath)
    rescue
      fail "Invalid xpath: #{context_xpath}"
    end

    return context_elements_cache[context_xpath]
  end
end
