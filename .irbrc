require 'irb/ext/save-history'
require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:USE_READLINE] = false
