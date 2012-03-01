class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  def string_to_float(string)

        string.gsub!(/[^\d.,]/,'')          # Replace all Currency Symbols, Letters and -- from the string

        if string =~ /^.*[\.,]\d{1}$/       # If string ends in a single digit (e.g. ,2)
          string = string + "0"             # make it ,20 in order for the result to be in "cents"
        end

        unless string =~ /^.*[\.,]\d{2}$/   # If does not end in ,00 / .00 then
          string = string + "00"            # add trailing 00 to turn it into cents
        end

        string.gsub!(/[\.,]/,'')            # Replace all (.) and (,) so the string result becomes in "cents"  
        string.to_f / 100                   # Let to_float do the rest
     end
     
end
