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

def get_ems_values(ems_objects, name)
  values = {}
  ems_objects.each do |ems_object|
    next unless ems_object.name.to_s.include? name.gsub(' ', '_')

    ems_object.lines.each do |line|
      next unless line.downcase.start_with? 'set'

      lhs, rhs = line.split('=')
      lhs = lhs.gsub('Set', '').gsub('set', '').strip
      rhs = rhs.gsub(',', '').gsub(';', '').strip
      values[lhs] = [] if values[lhs].nil?
      # eg. "Q = Q + 1.5"
      if rhs.include? '+'
        rhs_els = rhs.split('+')
        rhs = rhs_els.map { |s| s.tr('()', '').to_f }.sum(0.0)
      else
        rhs = rhs.to_f
      end
      values[lhs] << rhs
    end
  end
  return values
end
