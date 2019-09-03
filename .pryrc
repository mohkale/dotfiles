if ENV["INSIDE_EMACS"]
    Pry.config.pager = false 

    class Emacsable
       def self.readline(prompt)
           print prompt
           (gets || '').chomp
       end
    end

    Pry.config.input = Emacsable
end
