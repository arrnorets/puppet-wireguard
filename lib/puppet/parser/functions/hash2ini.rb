#
# A simple transformation of Puppet hash to INI file.
#

module Puppet::Parser::Functions
  newfunction(:hash2ini, :type => :rvalue, :doc => <<-EOS
    Returns INI-like data based on passed hash.
    EOS
  ) do |arguments|

        source_hash = arguments[0]
        delimiter = arguments[1]
        print_section_name = arguments[2]
        
        result = ""
        
        source_hash.each do |section_name, section|
            if ( print_section_name == true )
                result = result + "[" + "#{section_name}" + "]\n"
            end
            section.each do |key, value|
                result = result + "#{key}" + delimiter + "#{value}" + "\n"
            end
	    result = result + "  \n"
        end
    
        return result

    end
end

# vim: set ts=2 sw=2 et :
