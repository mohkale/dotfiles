if ENV["INSIDE_EMACS"]
    require 'irb/ext/save-history'
    require 'irb/completion'

    IRB.conf[:SAVE_HISTORY] = 200
    IRB.conf[:USE_READLINE] = false
    IRB.conf[:PROMPT_MODE]  = :DEFAULT
end
