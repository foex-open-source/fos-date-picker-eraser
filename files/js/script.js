/* global apex,$ */
window.FOS = window.FOS || {};
FOS.utils = FOS.utils || {};
FOS.utils.datePickerEraser = FOS.utils.datePickerEraser || {};

FOS.utils.datePickerEraser.addClearItemButton = function (daContext, config) {
    apex.debug.info('FOS - Date Picker Eraser:', config);

    const CLS_PREFIX = 'fos-dpe-clear-';
    const items = config.items;
    const icon = config.icon;

    if (!items) {
        return;
    }

    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        const item$ = $('#' + item);

        //skip readonly or not rendered items
        if (item$.siblings('.display_only').length || !item$.length) {
            continue;
        }

        let button$ = $('<button title="Clear Value" type="button" class="a-Button a-Button--calendar ' + CLS_PREFIX + 'btn"></button>');
        if (config.template.includes('icon')) {
            button$.append($('<span class="fa ' + icon + '"></span>'));
        }

        if (config.template.includes('text')) {
            let cls = (config.template.includes('icon')) ? 'text-with-icon' : 'text';
            button$.append($('<span class="' + CLS_PREFIX + cls + '">' + config.text + '</span>'));
        }

        button$.on('click', function () {
            apex.item(item).setValue(null, null);
        });

        // set the orientation
        if (config.orientation == 'left') {
            item$.parent().prepend(button$);
            let buttonCSS = {
                'box-shadow': 'rgb(0 0 0 / 10%) 1px -1px 0px 0px inset, rgb(0 0 0 / 10%) 0px 1px 0px 0px inset'
            };
            let offset = button$[0].getBoundingClientRect().width;
            let itemContainer$ = $('#' + item + '_CONTAINER');
            let label$ = itemContainer$.find('.t-Form-labelContainer label');
            if (label$ && label$.length > 0) {
                if (itemContainer$[0].className.includes('floatingLabel')) {
                    label$.css($('html').attr('dir') == 'rtl' ? 'right' : 'left', offset + 'px');
                }
                let borderRadius = getComputedStyle(button$[0]).borderTopRightRadius;
                buttonCSS = Object.assign(buttonCSS, { 'margin': '0', 'border-radius': borderRadius });
            }
            button$.css(buttonCSS);
        } else {
            item$.parent().append(button$)
        };
    }
}

