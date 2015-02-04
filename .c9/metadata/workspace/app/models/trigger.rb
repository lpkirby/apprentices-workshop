{"filter":false,"title":"trigger.rb","tooltip":"/app/models/trigger.rb","undoManager":{"mark":60,"position":60,"stack":[[{"group":"doc","deltas":[{"start":{"row":1,"column":0},"end":{"row":3,"column":0},"action":"remove","lines":["  belongs_to :exit","end",""]},{"start":{"row":1,"column":0},"end":{"row":17,"column":3},"action":"insert","lines":["  belongs_to :room","","  validates :room_id, uniqueness:  { scope: :room,","                                       message: \"Only one room special function allowed per room.\" }","  ","  before_create :default_values","  def default_values","    self.room_special_type ||= 'D'","    self.name ||= ''","    self.extended_value_1 ||= -1","    self.extended_value_2 ||= -1","    self.extended_value_3 ||= -1","    self.extended_value_4 ||= -1","    self.extended_value_5 ||= -1","  end","","end"]}]}],[{"group":"doc","deltas":[{"start":{"row":1,"column":14},"end":{"row":1,"column":18},"action":"remove","lines":["room"]},{"start":{"row":1,"column":14},"end":{"row":1,"column":15},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":1,"column":15},"end":{"row":1,"column":16},"action":"insert","lines":["x"]}]}],[{"group":"doc","deltas":[{"start":{"row":1,"column":16},"end":{"row":1,"column":17},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":1,"column":17},"end":{"row":1,"column":18},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":13},"end":{"row":3,"column":17},"action":"remove","lines":["room"]},{"start":{"row":3,"column":13},"end":{"row":3,"column":14},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":14},"end":{"row":3,"column":15},"action":"insert","lines":["x"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":15},"end":{"row":3,"column":16},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":16},"end":{"row":3,"column":17},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":45},"end":{"row":3,"column":49},"action":"remove","lines":["room"]},{"start":{"row":3,"column":45},"end":{"row":3,"column":46},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":46},"end":{"row":3,"column":47},"action":"insert","lines":["x"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":47},"end":{"row":3,"column":48},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":3,"column":48},"end":{"row":3,"column":49},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":9},"end":{"row":8,"column":26},"action":"remove","lines":["room_special_type"]},{"start":{"row":8,"column":9},"end":{"row":8,"column":10},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":10},"end":{"row":8,"column":11},"action":"insert","lines":["r"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":11},"end":{"row":8,"column":12},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":12},"end":{"row":8,"column":13},"action":"insert","lines":["g"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":13},"end":{"row":8,"column":14},"action":"insert","lines":["g"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":14},"end":{"row":8,"column":15},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":15},"end":{"row":8,"column":16},"action":"insert","lines":["r"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":16},"end":{"row":8,"column":17},"action":"insert","lines":["_"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":17},"end":{"row":8,"column":18},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":18},"end":{"row":8,"column":19},"action":"insert","lines":["y"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":19},"end":{"row":8,"column":20},"action":"insert","lines":["p"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":20},"end":{"row":8,"column":21},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":27},"end":{"row":8,"column":28},"action":"remove","lines":["D"]}]}],[{"group":"doc","deltas":[{"start":{"row":8,"column":27},"end":{"row":8,"column":28},"action":"insert","lines":["A"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":58},"end":{"row":4,"column":62},"action":"remove","lines":["room"]},{"start":{"row":4,"column":58},"end":{"row":4,"column":59},"action":"insert","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":59},"end":{"row":4,"column":60},"action":"insert","lines":["r"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":60},"end":{"row":4,"column":61},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":61},"end":{"row":4,"column":62},"action":"insert","lines":["g"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":62},"end":{"row":4,"column":63},"action":"insert","lines":["g"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":63},"end":{"row":4,"column":64},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":64},"end":{"row":4,"column":65},"action":"insert","lines":["r"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["s"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["p"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["c"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["a"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["l"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["f"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["u"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["n"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["c"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["t"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["o"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":["n"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"remove","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":65},"end":{"row":4,"column":66},"action":"insert","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":81},"end":{"row":4,"column":82},"action":"remove","lines":["m"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":80},"end":{"row":4,"column":81},"action":"remove","lines":["o"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":79},"end":{"row":4,"column":80},"action":"remove","lines":["o"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":78},"end":{"row":4,"column":79},"action":"remove","lines":["r"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":78},"end":{"row":4,"column":79},"action":"insert","lines":["e"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":79},"end":{"row":4,"column":80},"action":"insert","lines":["x"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":80},"end":{"row":4,"column":81},"action":"insert","lines":["i"]}]}],[{"group":"doc","deltas":[{"start":{"row":4,"column":81},"end":{"row":4,"column":82},"action":"insert","lines":["t"]}]}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":4,"column":82},"end":{"row":4,"column":82},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1423022734780,"hash":"533f32b095fb778a0b9bdad84a32dafabd9797bc"}