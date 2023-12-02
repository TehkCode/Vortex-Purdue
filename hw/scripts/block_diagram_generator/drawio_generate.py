import uuid

uid = lambda: uuid.uuid4().hex[:20] #20 char unique id

graph_dim = (1224,1224) #(dx,dy)
input_cordinates = (160,90)
output_cordinates = (680,90)
Box_cordinates = (280,80)
text_dim = (40,30)

signal_y_incr = 40

def _genrate_signal(signal_text_data, signal_box_coord, is_input_signal, box_uid):
  (signal_name, signal_uid, signal_text_coord) = signal_text_data
  if is_input_signal:
    conn_src_id = signal_uid
    conn_target_id = box_uid
    signal_entry_exit = f"entryX={signal_box_coord[0]};entryY={signal_box_coord[1]};entryDx=0;entryDy=0"
  else:
    conn_src_id = box_uid
    conn_target_id = signal_uid
    signal_entry_exit = f"exitX={signal_box_coord[0]};exitY={signal_box_coord[1]};exitDx=0;exitDy=0;"

  signal_format = f"""
  <object id="{signal_uid}" label="{signal_name}">
    <mxCell style="text;html=1;align=center;verticalAlign=middle;resizable=1;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
        <mxGeometry x="{signal_text_coord[0]}" y="{signal_text_coord[1]}" width="{text_dim[0]}" height="{text_dim[1]}" as="geometry" />
    </mxCell>
  </object>
  """
  signal_connect = f"""
  <object id="{signal_uid}_conn" label="" src_label="" trgt_label="" source="{conn_src_id}" target="{conn_target_id}">
    <mxCell style="Arrow=classic;{signal_entry_exit};entryPerimeter=0;" edge="1" parent="1" source="{conn_src_id}" target="{conn_target_id}">
        <mxGeometry relative="1" as="geometry" />
    </mxCell>
  </object>
"""
  return signal_format+signal_connect

def __generate_diagram(box_name, box_dimensions, box_uid, file_uid, xml_signals):
  diagram_data = f"""
  <diagram name="{box_name}" id="{file_uid}">
  <mxGraphModel dx="{graph_dim[0]}" dy="{graph_dim[1]}" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>  

  <mxCell id="0" />
  <mxCell id="1" parent="0" />

  <object id="{box_uid}" label="{box_name}">
  <mxCell style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
      <mxGeometry x="{Box_cordinates[0]}" y="{Box_cordinates[1]}" width="{box_dimensions[0]}" height="{box_dimensions[1]}" as="geometry" />
  </mxCell>
  </object>
  
  {xml_signals}

  </root>
  </mxGraphModel>
  </diagram>    
  """
  return diagram_data

def __write_drawio_xml(pages_data, output_filename):
  xml_data = f"""<?xml version="1.0" encoding="UTF-8"?>
  <mxfile type="device" compressed="false">
  {pages_data}
  </mxfile>
  """
  with open(output_filename, "w") as f:
    f.write(xml_data)

def __generate_page_data(module_name, input_signals, output_signals):
  file_uid = uid()
  box_uid = uid()

  input_signal_y_incr = 0
  output_signal_y_incr = 0
  
  #box height calcuation
  max_height = max(len(input_signals), len(output_signals))
  box_height = (max_height * signal_y_incr) + 20
  box_dimensions = (320, box_height) #(width,height)

  xml_signals = ""
  box_name = module_name

  for signal in input_signals:
    signal_coordinates = (input_cordinates[0], input_cordinates[1]+input_signal_y_incr)
    signal_entry_x = 0
    signal_entry_y = (signal_coordinates[1] - Box_cordinates[1] + 15)/box_height #15 is offset
    signal_entry_y = round(signal_entry_y, 3)
    signal_entry = (signal_entry_x, signal_entry_y)
    signal_text_data = (signal[2], uid(), signal_coordinates)
    
    xml_signals = xml_signals + _genrate_signal(signal_text_data, signal_entry, True, box_uid)
    input_signal_y_incr = input_signal_y_incr + signal_y_incr

  for signal in output_signals:
    signal_coordinates = (output_cordinates[0], output_cordinates[1]+output_signal_y_incr)
    signal_exit_x = 1
    signal_exit_y = (signal_coordinates[1] - Box_cordinates[1] + 15)/box_height #15 is offset
    signal_exit_y = round(signal_exit_y, 3)
    signal_exit = (signal_exit_x, signal_exit_y)
    signal_text_data = (signal[2], uid(), signal_coordinates)

    xml_signals = xml_signals + _genrate_signal(signal_text_data, signal_exit, False, box_uid)
    output_signal_y_incr = output_signal_y_incr + signal_y_incr
  
  return  __generate_diagram(box_name, box_dimensions, box_uid, file_uid, xml_signals)

def generate_page(module_name, input_signals, output_signals, output_filename):
  page_data = __generate_page_data(module_name, input_signals, output_signals)
  __write_drawio_xml(page_data, output_filename)

def generate_pages(modules_dict, output_filename):
  pages_data = ""
  for module in modules_dict:
    page_data = __generate_page_data(module, modules_dict[module][0], modules_dict[module][1])
    pages_data =  pages_data + page_data
    __write_drawio_xml(pages_data, output_filename)