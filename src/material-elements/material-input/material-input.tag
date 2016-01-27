<material-input>
    <div class="label-placeholder"></div>
    <div class="{input-content:true,not-empty:value,error:error}">
        <label for="input" name="label" if="{opts.label}">{opts.label}</label>
        <input type="{opts.type || 'text'}" disabled="{disabled}" placeholder="{opts.placeholder}" onkeyup="{changeValue}" value="{value}" autocomplete="off" name="input"/>
        <input type="hidden" value="{value}"  name="{opts.name||'default'}">
        <div class="iconWrapper" name="iconWrapper" if="{opts.icon}" >
            <material-button name="iconButton" center="true" waves-center="true" waves-color="{opts['waves-color']||'#fff'}"
                             rounded="true" waves-opacity="{opts['waves-opacity']||'0.6'}" waves-duration="{opts['waves-duration']||'600'}">
                <yield></yield>
            </material-button>
        </div>
    </div>
    <div class="{underline:true,focused:focused,error:error}">
        <div class="unfocused-line"></div>
        <div class="focused-line"></div>
    </div>

    <script type="es6">
        // Attributes
        this.update({value:opts.value || ''});
        // For Validation Mixin
        this.opts = opts;
        // From options
        this.disabled = opts.disabled || false;
        this.name = opts.name || 'input';
        // Not supported types
        this.notSupportedTypes = ['date','color','datetime','month','range','time'];
        if(this.notSupportedTypes.indexOf(opts.type)!=-1) throw new Error(`Sorry but we not support ${date} type yet!`);
        // Icons
        this.update({showIcon:false});
        // Ready
        this.on('mount',()=>{
            this.input.name = this.name || 'textarea';
        });
        /**
         * When element focus changed update expressions.
         */
        this.changeFocus = (e)=>{
            if(this.disabled) return false;
            this.update({focused:this['input']==document.activeElement});
            this.trigger('focusChanged',this.focused,e);
            if(opts.focuschanged&&(typeof(opts.focuschanged)==="function")){
                opts.focuschanged(this.focused);
            }
        }
        /**
         * Change input value should change tag behavior.
         * @param e
         */
        this.changeValue = (e)=>{
            this.update({value:this['input'].value});
            this.trigger('valueChanged',this['input'].value,e);
            if(opts.valuechanged&&(typeof(opts.valuechanged)==="function")){
                opts.valuechanged(this['input'].value);
            }
        }
        // Add event listeners to input.
        this['input'].addEventListener('focus',this.changeFocus);
        this['input'].addEventListener('blur',this.changeFocus);
        // Validation
        this.on('update',(updated)=>{
            if(updated && updated.value!=undefined) {
                if(this.validationType) {
                    this.isValid(this.validate(updated.value));
                }
            }
        });
        /**
         * Behevior after validation
         * @param isValid - (true/false)
         */
        this.isValid = (isValid)=>{
            this.update({error:!isValid});
        }
        this.mixin('validate');
    </script>
</material-input>