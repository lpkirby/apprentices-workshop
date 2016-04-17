{"changed":true,"filter":false,"title":"area.rb","tooltip":"/app/models/area.rb","value":"require_relative '_import'\nrequire_relative '_translate'\nrequire_relative '_lookup'\n\nclass Area < ActiveRecord::Base\n  belongs_to :user\n  has_many :helps, dependent: :destroy\n  has_many :rooms, dependent: :destroy\n  has_many :objs, dependent: :destroy\n  has_many :mobiles, dependent: :destroy\n  has_many :area_strings, dependent: :destroy\n  has_many :resets, dependent: :destroy\n  has_many :shares, dependent: :destroy\n  \n  has_many :applies, through: :objs\n  has_many :oxdescs, through: :objs\n  has_many :shops, through: :mobiles\n  has_many :specials, through: :mobiles\n  has_many :exits, through: :rooms\n  has_many :rxdescs, through: :rooms\n  has_many :room_specials, through: :rooms\n  has_many :sub_resets, through: :resets\n  has_many :triggers, through: :rooms, :source => :triggers\n  \n  include Bitfields\n  \n  bitfield :misc_flags,\n                    2**0 => :share_publicly,\n                    2**1 => :use_rulers,\n                    2**2 => :show_formatted_blocks\n  \n  bitfield  :flags, 2**0 => :manmade,  # Hex 1\n                    2**1 => :city,     # Hex 2\n                    2**2 => :forest,   # Hex 4\n                    2**3 => :limited,  # Hex 8\n                    2**4 => :aerial,   # Hex 10\n                    2**5 => :reserved, # Hex 20\n                    2**6 => :arena,    # Hex 40\n                    2**7 => :quest,    # Hex 80\n                    2**8 => :novnum,   # Hex 100\n                    2**9 => :no_save   # Hex 200\n                    \n  bitfield :default_room_flags, \n                2**0 =>  :dark,          # Dec:          1 / Hex:         1\n                2**1 =>  :no_sleep,      # Dec:          2 / Hex:         2\n                2**2 =>  :no_mob,        # Dec:          4 / Hex:         4\n                2**3 =>  :indoors,       # Dec:          8 / Hex:         8\n#               2**4 =>  :flag,          # Dec:         16 / Hex:        10\n                2**5 =>  :foggy,         # Dec:         32 / Hex:        20\n                2**6 =>  :fire,          # Dec:         64 / Hex:        40\n                2**7 =>  :lava,          # Dec:        128 / Hex:        80\n#               2**8 =>  :flag,          # Dec:        256 / Hex:       100\n                2**9 =>  :private_room,  # Dec:        512 / Hex:       200\n                2**10 => :peaceful,      # Dec:       1024 / Hex:       400\n                2**11 => :solitary,      # Dec:       2048 / Hex:       800\n#               2**12 => :flag,          # Dec:       4096 / Hex:      1000\n                2**13 => :no_recall,     # Dec:       8192 / Hex:      2000\n                2**14 => :no_steal,      # Dec:      16384 / Hex:      4000\n                2**15 => :notrans,       # Dec:      32768 / Hex:      8000\n                2**16 => :no_spell,      # Dec:      65536 / Hex:     10000\n                2**17 => :seafloor,      # Dec:     131072 / Hex:     20000\n                2**18 => :no_fly,        # Dec:     262144 / Hex:     40000\n                2**19 => :holy_ground,   # Dec:     524288 / Hex:     80000\n                2**20 => :fly_ok,        # Dec:    1048576 / Hex:    100000\n                2**21 => :no_quest,      # Dec:    2097152 / Hex:    200000\n                2**22 => :no_item,       # Dec:    4194304 / Hex:    400000\n                2**23 => :no_vnum        # Dec:    8388608 / Hex:    800000\n#               2**24 => :flag,          # Dec:   16777216 / Hex:   1000000\n#               2**25 => :flag,          # Dec:   33554432 / Hex:   2000000\n#               2**26 => :flag,          # Dec:   67108864 / Hex:   4000000\n#               2**27 => :flag,          # Dec:  134217728 / Hex:   8000000\n#               2**28 => :flag,          # Dec:  268435456 / Hex:  10000000\n#               2**29 => :flag,          # Dec:  536870912 / Hex:  20000000\n#               2**30 => :flag,          # Dec: 1073741824 / Hex:  40000000\n#               2**31 => :flag,          # Dec: 2147483648 / Hex:  80000000\n#               2**32 => :flag,          # Dec: 4294967296 / Hex: 100000000\n\n  validates :name, length: { in: 1..20 }\n  validates :author, length: { in: 1..75 }\n\n  validates :vnum_qty, numericality: { only_integer: true, greater_than_or_equal_to: 0 }\n  validates :lowlevel, numericality: { only_integer: true, greater_than: 0, less_than: 51  }\n  validates :highlevel, numericality: { only_integer: true, greater_than: 0, less_than: 51  }\n  validates :default_terrain, numericality: { only_integer: true, greater_than_or_equal_to: 0 }\n  validates :area_number,  numericality: { only_integer: true, greater_than: 0 }\n  validates :user_id,  numericality: { only_integer: true, greater_than: 0 }\n  \n  validate do |area|\n    area.errors.add :base, \"Name may only contain US-ASCII characters.  Invalid characters: \" + area.name.remove(/[\\x0A\\x0D -~]/) if area.name.remove(/[\\x0A\\x0D -~]/).length > 0\n    area.errors.add :base, \"Author may only contain US-ASCII characters.  Invalid characters: \" + area.author.remove(/[\\x0A\\x0D -~]/) if area.author.remove(/[\\x0A\\x0D -~]/).length > 0\n  end\n\n  before_create :default_values\n  def default_values\n    self.flags ||= 0\n    self.vnum_qty ||= 100\n    self.misc_flags ||= 0\n    self.default_terrain ||= 0\n    self.default_room_flags ||= 0\n    return true\n  end\n  \n  def self.import(file, user_id)\n\n    range_low ||= 0\n    range_high ||= 0\n    author ||= ''\n    name ||= ''\n    flags ||= 0\n    \n    area_file = file.read.encode(universal_newline: true).gsub(/\\s*\\n/,\"\\n\")\n    #lines = area_file.readlines.map(&:chomp) #readlines from file & removes newline symbol\n\n    header_v1 = 'No Format 1 Area Header'\n    header_v2 = 'No Format 2 Area Header'\n    mobiles_block = 'No Mobiles Block'\n    objects_block = 'No Objects Block'\n    rooms_block = 'No Rooms Block'\n    strings_block = 'No Strings Block'\n    resets_block = 'No Resets Block'\n    shops_block = 'No Shops Block'\n    specials_block = 'No Specials Block'\n    rspecs_block = 'No Room Specials Block'\n    triggers_block = 'No Triggers Block'\n    header_info = ''\n    \n    # Parse v1 Header Info\n    if area_file.match(/^#AREA.*~.*?\\n/)\n      header_v1 = area_file.match(/^#AREA.*~.*?\\n/)\n      header_info = parse_area_header_v1(header_v1[0], user_id)\n    end\n    # Parse v2 Header Info\n    if area_file.match(/^#AREA.*?\\nEnd/m)\n      header_v2 = area_file.match(/^#AREA.*?\\nEnd/m)\n      header_info = parse_area_header_v2(header_v2[0], user_id)\n    end\n    # Parse the Mobiles Block\n    if area_file.match(/^#MOBILES\\n#(.*?)\\n#0/m)\n      mobiles_block = parse_mobiles( area_file.match(/^#MOBILES\\n#(.*?)\\n#0/m)[1] )\n    end\n    # Parse the Objects Block\n    if area_file.match(/^#OBJECTS\\n#.*?\\n#0/m)\n      objects_block = parse_objects( area_file.match(/^#OBJECTS\\n#(.*?)\\n#0/m)[1] )\n    end\n    \n    \n    \n    if area_file.match(/^#ROOMS\\n#.*?\\n#0/m)\n      rooms_block = area_file.match(/^#ROOMS\\n#(.*?)\\n#0/m)\n    end\n    if area_file.match(/^#STRINGS\\n#.*?\\n#0/m)\n      strings_block = area_file.match(/^#STRINGS\\n#(.*?)\\n#0/m)\n    end\n    if area_file.match(/^#RESETS\\n.*?\\nS/m)\n      resets_block = area_file.match(/^#RESETS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#SHOPS\\n.*?\\n0/m)\n      shops_block = area_file.match(/^#SHOPS\\n.*?\\n0/m)\n    end\n    if area_file.match(/^#SPECIALS\\n.*?\\nS/m)\n      specials_block = area_file.match(/^#SPECIALS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#RSPECS\\n.*?\\nS/m)\n      rspecs_block = area_file.match(/^#RSPECS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#TRIGGERS\\n.*?\\nS/m)\n      triggers_block = area_file.match(/^#TRIGGERS\\n.*?\\nS/m)\n    end\n\n    return \"#{header_info}<hr>#{header_v1}<hr>#{header_v2}<hr>#{mobiles_block}<hr>#{objects_block}<hr>\" <<\n           \"#{rooms_block}<hr>#{strings_block}<hr>#{resets_block}<hr>#{shops_block}\" <<\n           \"#{specials_block}<hr>#{rspecs_block}<hr>#{triggers_block}<hr><b>EOF</b>\"\n\n  end\n  \n  def nextroomvnum\n    $i = 0\n    while self.rooms.exists?(:vnum => $i)  do\n        $i +=1\n    end\n    return $i\n  end\n  \n  def nextobjvnum\n    $i = 0\n    while self.objs.exists?(:vnum => $i)  do\n        $i +=1\n    end\n    return $i\n  end\n\n  def nextmobilevnum\n    $i = 0\n    while self.mobiles.exists?(:vnum => $i)  do\n        $i +=1\n    end\n    return $i\n  end\n\n  def nextarea_stringvnum\n    $i = 0\n    while self.area_strings.exists?(:vnum => $i)  do\n        $i +=1\n    end\n    return $i\n  end\n  \n  def flags_as_hex\n    #return self.flags.to_s(16).upper ... trying new\n    return \"%X\" % self.flags\n  end\n  \n  def flags_as_string\n    $flags_string = ''\n    $flags_string = $flags_string + ' MANMADE' if self.manmade\n    $flags_string = $flags_string + ' CITY' if self.city\n    $flags_string = $flags_string + ' FOREST' if self.forest\n    $flags_string = $flags_string + ' LIMITED' if self.limited\n    $flags_string = $flags_string + ' AERIAL' if self.aerial\n    $flags_string = $flags_string + ' RESERVED' if self.reserved\n    $flags_string = $flags_string + ' ARENA' if self.arena\n    $flags_string = $flags_string + ' QUEST' if self.quest\n    $flags_string = $flags_string + ' NOVNUM' if self.novnum\n    $flags_string = $flags_string + ' NOSAVE' if self.no_save\n    return $flags_string\n  end\n  \n  def door_reset_count\n    i = 0\n    self.rooms.each do |room|\n\n      room.exits.each do |exit|\n        i = i + 1 if exit.has_reset?\n      end\n\n    end\n    return i\n  end\n  \n  def shared_with?(this_user)\n#   if ( this_user.id == self.user_id || self.share_publicly? || this_user.is_admin? || self.shares.exists?(:user_id => this_user.id ) )\n    if self.shares.exists?(:user_id => this_user.id )\n      return true\n    else\n      return false\n    end\n  end\n\n  def my_area\n    return self\n  end\n  \n  def last_updated?\n    $latest_update = self.updated_at\n    $update = $latest_update\n    \n    $update = self.area_strings.order(updated_at: :desc).first.updated_at if self.area_strings.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    $update = self.helps.order(updated_at: :desc).first.updated_at if self.helps.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    $update = self.rooms.order(updated_at: :desc).first.updated_at if self.rooms.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    $update = self.mobiles.order(updated_at: :desc).first.updated_at if self.mobiles.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    $update = self.objs.order(updated_at: :desc).first.updated_at if self.objs.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    $update = self.resets.order(updated_at: :desc).first.updated_at if self.resets.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.shops.order(updated_at: :desc).first.updated_at if self.shops.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.specials.order(updated_at: :desc).first.updated_at if self.specials.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.room_specials.order(updated_at: :desc).first.updated_at if self.room_specials.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.sub_resets.order(updated_at: :desc).first.updated_at if self.sub_resets.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.triggers.order(updated_at: :desc).first.updated_at if self.triggers.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.applies.order(updated_at: :desc).first.updated_at if self.applies.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.exits.order(updated_at: :desc).first.updated_at if self.exits.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.rxdescs.order(updated_at: :desc).first.updated_at if self.rxdescs.count > 0\n    $latest_update = $update           if $update > $latest_update\n\n    $update = self.oxdescs.order(updated_at: :desc).first.updated_at if self.oxdescs.count > 0\n    $latest_update = $update           if $update > $latest_update\n    \n    return $latest_update\n  end\n  \n  def self.import(file, user_id)\n\n    range_low ||= 0\n    range_high ||= 0\n    author ||= ''\n    name ||= ''\n    flags ||= 0\n    \n    area_file = file.read.encode(universal_newline: true).gsub(/\\s*\\n/,\"\\n\")\n\n    mobiles_block = nil\n    objects_block = nil\n    rooms_block = nil\n    \n    strings_block = 'No Strings Block'\n    resets_block = 'No Resets Block'\n    shops_block = 'No Shops Block'\n    specials_block = 'No Specials Block'\n    rspecs_block = 'No Room Specials Block'\n    triggers_block = 'No Triggers Block'\n    header_info = nil\n    \n    if area_file.match(/^#AREA.*~.*?\\n/) # v1 Header\n      header_info = parse_area_header_v1( area_file.match(/^#AREA.*~.*?\\n/)[0] )\n    end\n    \n    if area_file.match(/^#AREA.*?\\nEnd/m) # v2 Header\n      header_info = parse_area_header_v2( area_file.match(/^#AREA.*?\\nEnd/m)[0] )\n    end\n\n    if area_file.match(/^#MOBILES\\n#(.*?)\\n#0/m)\n      mobiles_block = parse_mobiles( area_file.match(/^#MOBILES\\n#(.*?)\\n#0/m)[1] )\n    end\n\n    if area_file.match(/^#OBJECTS\\n#.*?\\n#0/m)\n      objects_block = parse_objects( area_file.match(/^#OBJECTS\\n#(.*?)\\n#0/m)[1] )\n    end\n    \n    if area_file.match(/^#ROOMS\\n#.*?\\n#0/m)\n      rooms_block = parse_rooms( area_file.match(/^#ROOMS\\n#(.*?)\\n#0/m)[1] )\n    end\n    \n    # --- BOOKMARK ---  Items below not started.\n    if area_file.match(/^#STRINGS\\n#.*?\\n#0/m)\n      strings_block = area_file.match(/^#STRINGS\\n#(.*?)\\n#0/m)\n    end\n    if area_file.match(/^#RESETS\\n.*?\\nS/m)\n      resets_block = area_file.match(/^#RESETS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#SHOPS\\n.*?\\n0/m)\n      shops_block = area_file.match(/^#SHOPS\\n.*?\\n0/m)\n    end\n    if area_file.match(/^#SPECIALS\\n.*?\\nS/m)\n      specials_block = area_file.match(/^#SPECIALS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#RSPECS\\n.*?\\nS/m)\n      rspecs_block = area_file.match(/^#RSPECS\\n.*?\\nS/m)\n    end\n    if area_file.match(/^#TRIGGERS\\n.*?\\nS/m)\n      triggers_block = area_file.match(/^#TRIGGERS\\n.*?\\nS/m)\n    end\n\n    return \"<h1>Header</h1>#{format_hash(header_info) if header_info != nil}<hr>\" <<\n           \"<h1>Mobiles</h1>#{format_hash(mobiles_block) if mobiles_block != nil}<hr>\" <<\n           \"<h1>Objects</h1>#{format_hash(objects_block) if objects_block != nil}<hr>\" <<\n           \"<h1>Rooms (WIP)</h1>#{format_hash(rooms_block) if rooms_block != nil}<hr>\" #<<\n           #\"#{rooms_block}<hr>#{strings_block}<hr>#{resets_block}<hr>#{shops_block}\" <<\n           #\"#{specials_block}<hr>#{rspecs_block}<hr>#{triggers_block}<hr><b>EOF</b>\"\n\n  end\n  \nend\n\ndef format_hash(h)\n  $formatted_hash = ''\n  \n    h.each do |item|\n      $formatted_hash = $formatted_hash + \"<b>#{item[0]}:</b> \"\n      if item[1].class.name == \"Hash\"\n        $formatted_hash = $formatted_hash + \"<table border=\\\"1\\\"><tr><td>#{format_hash(item[1])}</td></tr></table>\"\n      else\n        $formatted_hash = $formatted_hash + \"#{item[1]}<br>\"\n      end\n    end\n  \n  return $formatted_hash\nend\n\n","undoManager":{"mark":99,"position":100,"stack":[[{"start":{"row":442,"column":6},"end":{"row":442,"column":7},"action":"insert","lines":["="],"id":6770}],[{"start":{"row":442,"column":7},"end":{"row":442,"column":8},"action":"insert","lines":[" "],"id":6771}],[{"start":{"row":442,"column":8},"end":{"row":442,"column":9},"action":"insert","lines":["e"],"id":6772}],[{"start":{"row":442,"column":9},"end":{"row":442,"column":10},"action":"insert","lines":["x"],"id":6773}],[{"start":{"row":442,"column":8},"end":{"row":442,"column":10},"action":"remove","lines":["ex"],"id":6774},{"start":{"row":442,"column":8},"end":{"row":442,"column":17},"action":"insert","lines":["exit_data"]}],[{"start":{"row":442,"column":17},"end":{"row":442,"column":18},"action":"insert","lines":["."],"id":6775}],[{"start":{"row":442,"column":18},"end":{"row":442,"column":19},"action":"insert","lines":["m"],"id":6776}],[{"start":{"row":442,"column":19},"end":{"row":442,"column":20},"action":"insert","lines":["a"],"id":6777}],[{"start":{"row":442,"column":20},"end":{"row":442,"column":21},"action":"insert","lines":["t"],"id":6778}],[{"start":{"row":442,"column":18},"end":{"row":442,"column":21},"action":"remove","lines":["mat"],"id":6779},{"start":{"row":442,"column":18},"end":{"row":442,"column":23},"action":"insert","lines":["match"]}],[{"start":{"row":442,"column":23},"end":{"row":442,"column":25},"action":"insert","lines":["()"],"id":6780}],[{"start":{"row":442,"column":24},"end":{"row":442,"column":25},"action":"insert","lines":["/"],"id":6781}],[{"start":{"row":442,"column":25},"end":{"row":442,"column":26},"action":"insert","lines":["/"],"id":6784}],[{"start":{"row":442,"column":25},"end":{"row":442,"column":26},"action":"remove","lines":["/"],"id":6785}],[{"start":{"row":442,"column":25},"end":{"row":442,"column":35},"action":"insert","lines":["\\d\\n[^~]*~"],"id":6786}],[{"start":{"row":442,"column":35},"end":{"row":442,"column":36},"action":"insert","lines":["/"],"id":6787}],[{"start":{"row":442,"column":34},"end":{"row":442,"column":35},"action":"insert","lines":[")"],"id":6788}],[{"start":{"row":442,"column":29},"end":{"row":442,"column":30},"action":"insert","lines":["("],"id":6789}],[{"start":{"row":443,"column":0},"end":{"row":443,"column":37},"action":"insert","lines":["exit_info[\"description\"] = m[2].strip"],"id":6790}],[{"start":{"row":443,"column":0},"end":{"row":443,"column":2},"action":"insert","lines":["  "],"id":6791}],[{"start":{"row":443,"column":39},"end":{"row":444,"column":0},"action":"insert","lines":["",""],"id":6792},{"start":{"row":444,"column":0},"end":{"row":444,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":443,"column":2},"end":{"row":443,"column":4},"action":"insert","lines":["  "],"id":6793}],[{"start":{"row":442,"column":39},"end":{"row":443,"column":0},"action":"insert","lines":["",""],"id":6794},{"start":{"row":443,"column":0},"end":{"row":443,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":443,"column":4},"end":{"row":443,"column":5},"action":"insert","lines":["o"],"id":6795}],[{"start":{"row":443,"column":5},"end":{"row":443,"column":6},"action":"insert","lines":["o"],"id":6796}],[{"start":{"row":443,"column":6},"end":{"row":443,"column":7},"action":"insert","lines":["f"],"id":6797}],[{"start":{"row":443,"column":6},"end":{"row":443,"column":7},"action":"remove","lines":["f"],"id":6798}],[{"start":{"row":443,"column":5},"end":{"row":443,"column":6},"action":"remove","lines":["o"],"id":6799}],[{"start":{"row":443,"column":4},"end":{"row":443,"column":5},"action":"remove","lines":["o"],"id":6800}],[{"start":{"row":443,"column":4},"end":{"row":443,"column":5},"action":"insert","lines":["i"],"id":6801}],[{"start":{"row":443,"column":5},"end":{"row":443,"column":6},"action":"insert","lines":["f"],"id":6802}],[{"start":{"row":443,"column":6},"end":{"row":443,"column":7},"action":"insert","lines":[" "],"id":6803}],[{"start":{"row":443,"column":7},"end":{"row":443,"column":8},"action":"insert","lines":["m"],"id":6804}],[{"start":{"row":443,"column":7},"end":{"row":443,"column":8},"action":"remove","lines":["m"],"id":6805},{"start":{"row":443,"column":7},"end":{"row":444,"column":4},"action":"insert","lines":["my_area","    "]}],[{"start":{"row":444,"column":2},"end":{"row":444,"column":4},"action":"remove","lines":["  "],"id":6806}],[{"start":{"row":444,"column":0},"end":{"row":444,"column":2},"action":"remove","lines":["  "],"id":6807}],[{"start":{"row":443,"column":14},"end":{"row":444,"column":0},"action":"remove","lines":["",""],"id":6808}],[{"start":{"row":443,"column":13},"end":{"row":443,"column":14},"action":"remove","lines":["a"],"id":6809}],[{"start":{"row":443,"column":12},"end":{"row":443,"column":13},"action":"remove","lines":["e"],"id":6810}],[{"start":{"row":443,"column":11},"end":{"row":443,"column":12},"action":"remove","lines":["r"],"id":6811}],[{"start":{"row":443,"column":10},"end":{"row":443,"column":11},"action":"remove","lines":["a"],"id":6812}],[{"start":{"row":443,"column":9},"end":{"row":443,"column":10},"action":"remove","lines":["_"],"id":6813}],[{"start":{"row":443,"column":8},"end":{"row":443,"column":9},"action":"remove","lines":["y"],"id":6814}],[{"start":{"row":444,"column":4},"end":{"row":444,"column":6},"action":"insert","lines":["  "],"id":6815}],[{"start":{"row":445,"column":2},"end":{"row":446,"column":0},"action":"insert","lines":["",""],"id":6816},{"start":{"row":446,"column":0},"end":{"row":446,"column":2},"action":"insert","lines":["  "]}],[{"start":{"row":445,"column":2},"end":{"row":445,"column":4},"action":"insert","lines":["  "],"id":6817}],[{"start":{"row":445,"column":4},"end":{"row":445,"column":5},"action":"insert","lines":["e"],"id":6818}],[{"start":{"row":445,"column":5},"end":{"row":445,"column":6},"action":"insert","lines":["l"],"id":6819}],[{"start":{"row":445,"column":6},"end":{"row":445,"column":7},"action":"insert","lines":["s"],"id":6820}],[{"start":{"row":445,"column":7},"end":{"row":445,"column":8},"action":"insert","lines":["e"],"id":6821}],[{"start":{"row":445,"column":4},"end":{"row":445,"column":8},"action":"remove","lines":["else"],"id":6822},{"start":{"row":445,"column":4},"end":{"row":445,"column":8},"action":"insert","lines":["else"]}],[{"start":{"row":445,"column":8},"end":{"row":446,"column":0},"action":"insert","lines":["",""],"id":6823},{"start":{"row":446,"column":0},"end":{"row":446,"column":6},"action":"insert","lines":["      "]}],[{"start":{"row":446,"column":6},"end":{"row":446,"column":7},"action":"insert","lines":["e"],"id":6824}],[{"start":{"row":446,"column":7},"end":{"row":446,"column":8},"action":"insert","lines":["n"],"id":6825}],[{"start":{"row":446,"column":8},"end":{"row":446,"column":9},"action":"insert","lines":["s"],"id":6826}],[{"start":{"row":446,"column":8},"end":{"row":446,"column":9},"action":"remove","lines":["s"],"id":6827}],[{"start":{"row":446,"column":8},"end":{"row":446,"column":9},"action":"insert","lines":["d"],"id":6828},{"start":{"row":446,"column":4},"end":{"row":446,"column":6},"action":"remove","lines":["  "]}],[{"start":{"row":445,"column":8},"end":{"row":446,"column":0},"action":"insert","lines":["",""],"id":6829},{"start":{"row":446,"column":0},"end":{"row":446,"column":6},"action":"insert","lines":["      "]}],[{"start":{"row":446,"column":6},"end":{"row":446,"column":43},"action":"insert","lines":["exit_info[\"description\"] = m[2].strip"],"id":6830}],[{"start":{"row":446,"column":33},"end":{"row":446,"column":43},"action":"remove","lines":["m[2].strip"],"id":6831},{"start":{"row":446,"column":33},"end":{"row":446,"column":34},"action":"insert","lines":["\""]}],[{"start":{"row":446,"column":34},"end":{"row":446,"column":35},"action":"insert","lines":["e"],"id":6832}],[{"start":{"row":446,"column":35},"end":{"row":446,"column":36},"action":"insert","lines":["r"],"id":6833}],[{"start":{"row":446,"column":36},"end":{"row":446,"column":37},"action":"insert","lines":["r"],"id":6834}],[{"start":{"row":446,"column":37},"end":{"row":446,"column":38},"action":"insert","lines":["o"],"id":6835}],[{"start":{"row":446,"column":38},"end":{"row":446,"column":39},"action":"insert","lines":["r"],"id":6836}],[{"start":{"row":446,"column":39},"end":{"row":446,"column":40},"action":"insert","lines":["\""],"id":6837}],[{"start":{"row":446,"column":39},"end":{"row":446,"column":40},"action":"insert","lines":["<"],"id":6838}],[{"start":{"row":446,"column":40},"end":{"row":446,"column":41},"action":"insert","lines":["b"],"id":6839}],[{"start":{"row":446,"column":41},"end":{"row":446,"column":42},"action":"insert","lines":[">"],"id":6840}],[{"start":{"row":446,"column":41},"end":{"row":446,"column":42},"action":"insert","lines":["/"],"id":6841}],[{"start":{"row":446,"column":41},"end":{"row":446,"column":42},"action":"remove","lines":["/"],"id":6842}],[{"start":{"row":446,"column":40},"end":{"row":446,"column":41},"action":"insert","lines":["/"],"id":6843}],[{"start":{"row":446,"column":34},"end":{"row":446,"column":35},"action":"insert","lines":["<"],"id":6844}],[{"start":{"row":446,"column":35},"end":{"row":446,"column":36},"action":"insert","lines":["b"],"id":6845}],[{"start":{"row":446,"column":36},"end":{"row":446,"column":37},"action":"insert","lines":[">"],"id":6846}],[{"start":{"row":444,"column":35},"end":{"row":444,"column":36},"action":"remove","lines":["2"],"id":6847},{"start":{"row":444,"column":35},"end":{"row":444,"column":36},"action":"insert","lines":["1"]}],[{"start":{"row":445,"column":0},"end":{"row":447,"column":7},"action":"remove","lines":["    else","      exit_info[\"description\"] = \"<b>error</b>\"","    end"],"id":6848}],[{"start":{"row":444,"column":43},"end":{"row":445,"column":0},"action":"remove","lines":["",""],"id":6849}],[{"start":{"row":443,"column":0},"end":{"row":443,"column":8},"action":"remove","lines":["    if m"],"id":6850}],[{"start":{"row":442,"column":39},"end":{"row":443,"column":0},"action":"remove","lines":["",""],"id":6851}],[{"start":{"row":443,"column":4},"end":{"row":443,"column":6},"action":"remove","lines":["  "],"id":6852}],[{"start":{"row":449,"column":40},"end":{"row":450,"column":0},"action":"insert","lines":["",""],"id":6853},{"start":{"row":450,"column":0},"end":{"row":450,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":450,"column":4},"end":{"row":451,"column":0},"action":"insert","lines":["",""],"id":6854},{"start":{"row":451,"column":0},"end":{"row":451,"column":4},"action":"insert","lines":["    "]}],[{"start":{"row":451,"column":4},"end":{"row":453,"column":7},"action":"insert","lines":["    if object.match(/^F$/)","      object_info[\"flammable\"] = true","    end"],"id":6855}],[{"start":{"row":451,"column":6},"end":{"row":451,"column":8},"action":"remove","lines":["  "],"id":6856}],[{"start":{"row":451,"column":4},"end":{"row":451,"column":6},"action":"remove","lines":["  "],"id":6857}],[{"start":{"row":451,"column":22},"end":{"row":451,"column":23},"action":"remove","lines":["F"],"id":6858},{"start":{"row":451,"column":22},"end":{"row":451,"column":23},"action":"insert","lines":["O"]}],[{"start":{"row":451,"column":26},"end":{"row":452,"column":0},"action":"insert","lines":["",""],"id":6859},{"start":{"row":452,"column":0},"end":{"row":452,"column":6},"action":"insert","lines":["      "]}],[{"start":{"row":452,"column":6},"end":{"row":452,"column":7},"action":"insert","lines":["m"],"id":6860}],[{"start":{"row":452,"column":7},"end":{"row":452,"column":8},"action":"insert","lines":[" "],"id":6861}],[{"start":{"row":452,"column":8},"end":{"row":452,"column":9},"action":"insert","lines":["="],"id":6862}],[{"start":{"row":452,"column":9},"end":{"row":452,"column":10},"action":"insert","lines":[" "],"id":6863}],[{"start":{"row":452,"column":10},"end":{"row":452,"column":19},"action":"insert","lines":["^O\\n(.*)~"],"id":6864}],[{"start":{"row":452,"column":6},"end":{"row":452,"column":10},"action":"remove","lines":["m = "],"id":6865},{"start":{"row":452,"column":6},"end":{"row":452,"column":55},"action":"insert","lines":["m = exit_data.match(/^(.*)~\\n(\\d*) (\\d*) (\\d*)$/)"]}],[{"start":{"row":452,"column":55},"end":{"row":452,"column":64},"action":"remove","lines":["^O\\n(.*)~"],"id":6866}],[{"start":{"row":452,"column":27},"end":{"row":452,"column":53},"action":"remove","lines":["^(.*)~\\n(\\d*) (\\d*) (\\d*)$"],"id":6867},{"start":{"row":452,"column":27},"end":{"row":452,"column":36},"action":"insert","lines":["^O\\n(.*)~"]}],[{"start":{"row":453,"column":19},"end":{"row":453,"column":28},"action":"remove","lines":["flammable"],"id":6868},{"start":{"row":453,"column":19},"end":{"row":453,"column":23},"action":"insert","lines":["name"]}],[{"start":{"row":453,"column":28},"end":{"row":453,"column":32},"action":"remove","lines":["true"],"id":6869},{"start":{"row":453,"column":28},"end":{"row":453,"column":38},"action":"insert","lines":["m[1].strip"]}],[{"start":{"row":451,"column":7},"end":{"row":451,"column":13},"action":"remove","lines":["object"],"id":6870},{"start":{"row":451,"column":7},"end":{"row":451,"column":16},"action":"insert","lines":["exit_data"]}],[{"start":{"row":453,"column":6},"end":{"row":453,"column":17},"action":"remove","lines":["object_info"],"id":6871},{"start":{"row":453,"column":6},"end":{"row":453,"column":15},"action":"insert","lines":["exit_info"]}],[{"start":{"row":392,"column":0},"end":{"row":461,"column":3},"action":"remove","lines":["def parse_rooms(rooms_block)","  rooms_info = Hash.new","  i = 1","  ","  rooms = rooms_block.split(\"#\").map(&:strip)","  ","  rooms.each do |room|","    m = room.match(/^(\\d+)\\n(.*)~\\n([^~]*)\\n~\\n(\\d*) ([0-9|]*) (\\d*)/)","    room_info = Hash.new","    room_info[\"vnum\"]        = m[1].to_i","    room_info[\"name\"]        = m[2].strip","    room_info[\"description\"] = m[3].strip","    room_info[\"area_number\"] = m[4].to_i","    room_info[\"room_flags\"]  = read_flags( m[5].strip )","    room_info[\"terrain\"]     = m[6].to_i","    ","    if room.match(/^E$/) # any extra descriptions?","      room_info[\"extra_descs\"] = parse_extra_descs( room.split(/^E$/).map(&:strip) )","    end","    ","    if room.match(/^D\\d$/) # any exits?","      #room_info[\"exits\"] = parse_exits( room.split(/^D$/).map(&:strip) )","      ","      room_info[\"exits\"] = parse_exits( room.match(/^D\\d\\n[^#]*^S$/)[0] ) # Parse from 1st exit to end-of-room","    end","    ","    rooms_info[i] = room_info","    i = i + 1","  end","  ","  return rooms_info","end","","def parse_exits(exits_block)","  exits_block.gsub!(/^D(\\d)$/,'Exit: \\1')","  exits_block.gsub!(/^E\\n^.*~\\n[^~]*~/, '') # remove extra descriptions","  exits_block.gsub!(/^S$/, '') # remove trailing S","  ","  exits_list = exits_block.split(/^Exit: /).map(&:strip)","  exits_list.shift","  ","  exits_info = Hash.new","  i = 1","  ","  exits_list.each do |exit_data|","    exit_info = Hash.new","    ","    m = exit_data.match(/^(\\d)$/)","    exit_info[\"direction\"]   = m[1].to_i","    ","    m = exit_data.match(/\\d\\n([^~]*)~/)","    exit_info[\"description\"] = m[1].strip","  ","    m = exit_data.match(/^(.*)~\\n(\\d*) (\\d*) (\\d*)$/)","    exit_info[\"keywords\"]    = ( m[1].strip == nil ? \"\" : m[1].strip )","    exit_info[\"exittype\"]    = m[2].to_i","    exit_info[\"key_vnum\"]    = m[3].to_i","    exit_info[\"exit_vnum\"]   = m[4].to_i","    ","    if exit_data.match(/^O$/)","      m = exit_data.match(/^O\\n(.*)~/)","      exit_info[\"name\"] = m[1].strip","    end","    ","    exits_info[i] = exit_info","    i = i + 1","  end","  ","  return exits_info","end"],"id":6872}]]},"ace":{"folds":[],"scrolltop":5349,"scrollleft":0,"selection":{"start":{"row":392,"column":0},"end":{"row":392,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":143,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1460864213531}