{"filter":false,"title":"_import.rb","tooltip":"/app/models/_import.rb","undoManager":{"mark":19,"position":19,"stack":[[{"start":{"row":215,"column":3},"end":{"row":216,"column":0},"action":"insert","lines":["",""],"id":666}],[{"start":{"row":216,"column":0},"end":{"row":217,"column":0},"action":"insert","lines":["",""],"id":667}],[{"start":{"row":217,"column":0},"end":{"row":286,"column":3},"action":"insert","lines":["def parse_rooms(rooms_block)","  rooms_info = Hash.new","  i = 1","  ","  rooms = rooms_block.split(\"#\").map(&:strip)","  ","  rooms.each do |room|","    m = room.match(/^(\\d+)\\n(.*)~\\n([^~]*)\\n~\\n(\\d*) ([0-9|]*) (\\d*)/)","    room_info = Hash.new","    room_info[\"vnum\"]        = m[1].to_i","    room_info[\"name\"]        = m[2].strip","    room_info[\"description\"] = m[3].strip","    room_info[\"area_number\"] = m[4].to_i","    room_info[\"room_flags\"]  = read_flags( m[5].strip )","    room_info[\"terrain\"]     = m[6].to_i","    ","    if room.match(/^E$/) # any extra descriptions?","      room_info[\"extra_descs\"] = parse_extra_descs( room.split(/^E$/).map(&:strip) )","    end","    ","    if room.match(/^D\\d$/) # any exits?","      #room_info[\"exits\"] = parse_exits( room.split(/^D$/).map(&:strip) )","      ","      room_info[\"exits\"] = parse_exits( room.match(/^D\\d\\n[^#]*^S$/)[0] ) # Parse from 1st exit to end-of-room","    end","    ","    rooms_info[i] = room_info","    i = i + 1","  end","  ","  return rooms_info","end","","def parse_exits(exits_block)","  exits_block.gsub!(/^D(\\d)$/,'Exit: \\1')","  exits_block.gsub!(/^E\\n^.*~\\n[^~]*~/, '') # remove extra descriptions","  exits_block.gsub!(/^S$/, '') # remove trailing S","  ","  exits_list = exits_block.split(/^Exit: /).map(&:strip)","  exits_list.shift","  ","  exits_info = Hash.new","  i = 1","  ","  exits_list.each do |exit_data|","    exit_info = Hash.new","    ","    m = exit_data.match(/^(\\d)$/)","    exit_info[\"direction\"]   = m[1].to_i","    ","    m = exit_data.match(/\\d\\n([^~]*)~/)","    exit_info[\"description\"] = m[1].strip","  ","    m = exit_data.match(/^(.*)~\\n(\\d*) (\\d*) (\\d*)$/)","    exit_info[\"keywords\"]    = ( m[1].strip == nil ? \"\" : m[1].strip )","    exit_info[\"exittype\"]    = m[2].to_i","    exit_info[\"key_vnum\"]    = m[3].to_i","    exit_info[\"exit_vnum\"]   = m[4].to_i","    ","    if exit_data.match(/^O$/)","      m = exit_data.match(/^O\\n(.*)~/)","      exit_info[\"name\"] = m[1].strip","    end","    ","    exits_info[i] = exit_info","    i = i + 1","  end","  ","  return exits_info","end"],"id":668}],[{"start":{"row":286,"column":3},"end":{"row":287,"column":0},"action":"insert","lines":["",""],"id":669}],[{"start":{"row":287,"column":0},"end":{"row":288,"column":0},"action":"insert","lines":["",""],"id":670}],[{"start":{"row":288,"column":0},"end":{"row":307,"column":3},"action":"insert","lines":["def parse_helps( helps_block )","  helps_info = Hash.new","  i = 1","  ","  helps = helps_block.split(/^~$/).map(&:strip)","  helps.pop","  helps.each do |help|","    help_info = Hash.new","    ","    m = help.match(/^(\\d*) (.*)~\\n([^~]*)/)","    help_info[\"min_level\"] = m[1].to_i","    help_info[\"keywords\"]  = m[2].strip","    help_info[\"body\"]      = m[3].strip","    ","    helps_info[i] = help_info","    i = i + 1","  end","  ","  return helps_info","end"],"id":671}],[{"start":{"row":307,"column":3},"end":{"row":308,"column":0},"action":"insert","lines":["",""],"id":672}],[{"start":{"row":308,"column":0},"end":{"row":309,"column":0},"action":"insert","lines":["",""],"id":673}],[{"start":{"row":309,"column":0},"end":{"row":328,"column":3},"action":"insert","lines":["def parse_strings( strings_block )","  strings_info = Hash.new","  i = 1","  ","  string_sets = strings_block.split(\"#\").map(&:strip)","","  string_sets.each do |string_set|","    string_info = Hash.new","    ","    m = string_set.match(/^(\\d*)\\n(.*)\\n~\\n(.*)\\n~/)","    string_info[\"min_level\"] = m[1].to_i","    string_info[\"keywords\"]  = m[2].strip","    string_info[\"body\"]      = m[3].strip","    ","    strings_info[i] = string_info","    i = i + 1","  end","  ","  return strings_info","end"],"id":674}],[{"start":{"row":328,"column":3},"end":{"row":329,"column":0},"action":"insert","lines":["",""],"id":675}],[{"start":{"row":329,"column":0},"end":{"row":330,"column":0},"action":"insert","lines":["",""],"id":676}],[{"start":{"row":330,"column":0},"end":{"row":358,"column":3},"action":"insert","lines":["def parse_resets (resets_block)","  resets_info = Hash.new","  i = 1","  ","  resets_block.gsub!(/^\\*.*\\n/,'')","  resets = resets_block.split(/\\n/).map(&:strip)","  ","  resets.each do |reset|","    reset_info = Hash.new","","    m = reset.match(/(\\w) (\\d*) (\\d*) (\\d*)/)","    if m","      reset_info[\"reset_type\"] = m[1].strip","      reset_info[\"reset_v0\"]   = m[2].to_i","      reset_info[\"reset_v1\"]   = m[3].to_i","      reset_info[\"reset_v2\"]   = m[4].to_i","    end","    ","    m = reset.match(/\\w \\d* \\d* \\d* (\\d*)/)","    if m","      reset_info[\"reset_v3\"]   = m[1].to_i","    end","    ","    resets_info[i] = reset_info","    i = i + 1  ","  end","  ","  return resets_info","end"],"id":677}],[{"start":{"row":330,"column":0},"end":{"row":358,"column":3},"action":"remove","lines":["def parse_resets (resets_block)","  resets_info = Hash.new","  i = 1","  ","  resets_block.gsub!(/^\\*.*\\n/,'')","  resets = resets_block.split(/\\n/).map(&:strip)","  ","  resets.each do |reset|","    reset_info = Hash.new","","    m = reset.match(/(\\w) (\\d*) (\\d*) (\\d*)/)","    if m","      reset_info[\"reset_type\"] = m[1].strip","      reset_info[\"reset_v0\"]   = m[2].to_i","      reset_info[\"reset_v1\"]   = m[3].to_i","      reset_info[\"reset_v2\"]   = m[4].to_i","    end","    ","    m = reset.match(/\\w \\d* \\d* \\d* (\\d*)/)","    if m","      reset_info[\"reset_v3\"]   = m[1].to_i","    end","    ","    resets_info[i] = reset_info","    i = i + 1  ","  end","  ","  return resets_info","end"],"id":678},{"start":{"row":330,"column":0},"end":{"row":358,"column":3},"action":"insert","lines":["def parse_resets (resets_block)","  resets_info = Hash.new","  i = 1","  ","  resets_block.gsub!(/^\\*.*\\n/,'')","  resets = resets_block.split(/\\n/).map(&:strip)","  ","  resets.each do |reset|","    reset_info = Hash.new","","    m = reset.match(/(\\w) (\\d*) (\\d*) (\\d*)/)","    if m","      reset_info[\"reset_type\"] = m[1].strip","      reset_info[\"reset_v0\"]   = m[2].to_i","      reset_info[\"reset_v1\"]   = m[3].to_i","      reset_info[\"reset_v2\"]   = m[4].to_i","    end","    ","    m = reset.match(/\\w \\d* \\d* \\d* (\\d*)/)","    if m","      reset_info[\"reset_v3\"]   = m[1].to_i","    end","    ","    resets_info[i] = reset_info","    i = i + 1  ","  end","  ","  return resets_info","end"]}],[{"start":{"row":358,"column":3},"end":{"row":359,"column":0},"action":"insert","lines":["",""],"id":679}],[{"start":{"row":359,"column":0},"end":{"row":360,"column":0},"action":"insert","lines":["",""],"id":680}],[{"start":{"row":360,"column":0},"end":{"row":388,"column":3},"action":"insert","lines":["def parse_shops (shops_block)","  shops_info = Hash.new","  i = 1","  ","  shops_block.gsub!(/^\\*.*\\n/,'') # remove any commented out lines","  shops = shops_block.split(/\\n/).map(&:strip)","  ","  shops.each do |shop|","    shop_info = Hash.new","","    m = shop.match(/^(\\d*)\\s*(\\d*)\\s*(\\d*)\\s*(\\d*)\\s*(\\d*)\\s*(\\d*)\\s*\\d*\\s*\\d*\\s*(\\d*)\\s*(\\d*)\\s*([0-9-]*)/)","    if m","      shop_info[\"mobile_vnum\"] = m[1].to_i","      shop_info[\"buy_type_1\"]  = m[2].to_i","      shop_info[\"buy_type_2\"]  = m[3].to_i","      shop_info[\"buy_type_3\"]  = m[4].to_i","      shop_info[\"buy_type_4\"]  = m[5].to_i","      shop_info[\"buy_type_5\"]  = m[6].to_i","      shop_info[\"open_hour\"]   = m[7].to_i","      shop_info[\"close_hour\"]  = m[8].to_i","      shop_info[\"race\"]        = m[9].to_i","    end","","    shops_info[i] = shop_info","    i = i + 1  ","  end","  ","  return shops_info","end"],"id":681}],[{"start":{"row":60,"column":32},"end":{"row":60,"column":35},"action":"remove","lines":["\"#\""],"id":682},{"start":{"row":60,"column":32},"end":{"row":60,"column":36},"action":"insert","lines":["/^#/"]}],[{"start":{"row":110,"column":32},"end":{"row":110,"column":35},"action":"remove","lines":["\"#\""],"id":683},{"start":{"row":110,"column":32},"end":{"row":110,"column":36},"action":"insert","lines":["/^#/"]}],[{"start":{"row":221,"column":28},"end":{"row":221,"column":31},"action":"remove","lines":["\"#\""],"id":684},{"start":{"row":221,"column":28},"end":{"row":221,"column":32},"action":"insert","lines":["/^#/"]}],[{"start":{"row":313,"column":36},"end":{"row":313,"column":39},"action":"remove","lines":["\"#\""],"id":685},{"start":{"row":313,"column":36},"end":{"row":313,"column":40},"action":"insert","lines":["/^#/"]}]]},"ace":{"folds":[],"scrolltop":4264,"scrollleft":0,"selection":{"start":{"row":313,"column":54},"end":{"row":313,"column":54},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":303,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1460913134303,"hash":"1d130f8e574690d2057ad10ac7782d6cc5f04ffd"}