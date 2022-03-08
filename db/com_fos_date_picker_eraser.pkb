create or replace package body com_fos_date_picker_eraser
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in add a clear button the Date Picker items.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-date-picker-eraser
--
-- =============================================================================
function render
  ( p_dynamic_action in apex_plugin.t_dynamic_action
  , p_plugin         in apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_render_result
as
    l_result     apex_plugin.t_dynamic_action_render_result;

    --attributes
    l_items         p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_template      p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_02;
    l_text          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_03;
    l_icon          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_04;
    l_orientation   p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_05;

begin

    --debug
    if apex_application.g_debug and substr(:DEBUG,6) >= 6
    then
        apex_plugin_util.debug_dynamic_action
          ( p_plugin         => p_plugin
          , p_dynamic_action => p_dynamic_action
          );
    end if;

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write('template'    , l_template    );
    apex_json.write('text'        , l_text        );
    apex_json.write('icon'        , l_icon        );
    apex_json.write('orientation' , l_orientation );

    apex_json.open_array('items');

    for item in
      ( select item_name
          from apex_application_page_items
         where application_id  = :APP_ID
           and page_id in (:APP_PAGE_ID,0)
           and display_as_code = 'NATIVE_DATE_PICKER'
           and ( l_items is null
              or item_name    in ( select column_value
                                     from apex_string.split(l_items, ',')
                                 )
               )
      )
    loop
        apex_json.write(item.item_name);
    end loop;

    apex_json.close_array;

    apex_json.close_object;

    l_result.javascript_function := 'function(){return FOS.utils.datePickerEraser.addClearItemButton(this,' || apex_json.get_clob_output || ');}';

    apex_json.free_output;

    return l_result;
end render;

end;
/


