{"filter":false,"title":"mobiles_controller.rb","tooltip":"/app/controllers/mobiles_controller.rb","undoManager":{"mark":6,"position":6,"stack":[[{"group":"doc","deltas":[{"start":{"row":71,"column":93},"end":{"row":72,"column":0},"action":"insert","lines":["",""]},{"start":{"row":72,"column":0},"end":{"row":72,"column":6},"action":"insert","lines":["      "]}]}],[{"group":"doc","deltas":[{"start":{"row":72,"column":0},"end":{"row":72,"column":6},"action":"remove","lines":["      "]},{"start":{"row":72,"column":0},"end":{"row":76,"column":9},"action":"insert","lines":["      if params[:return_to_room]","        redirect_to area_room_path(@area, params[:return_to_room]), notice: 'Reset was sucessfully updated.'","      else","        redirect_to area_reset_path(@area, @reset), notice: 'Reset was sucessfully updated.'","      end"]}]}],[{"group":"doc","deltas":[{"start":{"row":71,"column":6},"end":{"row":71,"column":93},"action":"remove","lines":["redirect_to area_mobile_path(@area, @mobile), notice: 'Mobile was sucessfully updated.'"]}]}],[{"group":"doc","deltas":[{"start":{"row":71,"column":0},"end":{"row":71,"column":6},"action":"remove","lines":["      "]}]}],[{"group":"doc","deltas":[{"start":{"row":71,"column":0},"end":{"row":72,"column":0},"action":"remove","lines":["",""]}]}],[{"group":"doc","deltas":[{"start":{"row":74,"column":8},"end":{"row":74,"column":92},"action":"remove","lines":["redirect_to area_reset_path(@area, @reset), notice: 'Reset was sucessfully updated.'"]},{"start":{"row":74,"column":8},"end":{"row":74,"column":95},"action":"insert","lines":["redirect_to area_mobile_path(@area, @mobile), notice: 'Mobile was sucessfully updated.'"]}]}],[{"group":"doc","deltas":[{"start":{"row":72,"column":77},"end":{"row":72,"column":82},"action":"remove","lines":["Reset"]},{"start":{"row":72,"column":77},"end":{"row":72,"column":83},"action":"insert","lines":["Mobile"]}]}]]},"ace":{"folds":[],"scrolltop":780,"scrollleft":0,"selection":{"start":{"row":71,"column":0},"end":{"row":75,"column":9},"isBackwards":true},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":54,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1424752851078,"hash":"64841febb27f81ddf9bd97e9dd9e54176e7b7a7f"}