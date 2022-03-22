package;

import haxe.Constraints.Function;
import js.html.FormElement;
import utils.UUID;
import js.Browser.*;
import js.Browser;
import js.html.*;
import model.constants.App;

class Json2Form {
	var formJson:Json2Form.ConfigObj;
	var cb:Function;
	var form:FormElement;
	var container:js.html.DivElement;

	public static function create(selector:String, json:ConfigObj, cb:Function):FormElement {
		var jsForm = new Json2Form(selector, json, cb);
		return jsForm.form;
	}

	public function new(selector:String, json:ConfigObj, cb:Function) {
		this.container = cast document.querySelector(selector);
		this.formJson = json;
		this.cb = cb;

		var id = UUID.uuid();
		if (Reflect.hasField(json.form, 'id')) {
			id = Reflect.getProperty(json.form, 'id');
		}

		form = document.createFormElement();
		form.id = id;
		form.name = 'x';
		form.onsubmit = onSubmitHandler;
		for (i in Reflect.fields(formJson.form)) {
			var obj = Reflect.field(formJson.form, i);
			if (i == 'id' || i == 'onsubmit')
				continue;

			formInputCreate(form, i, obj);
		}

		// add form to container
		container.appendChild(form);
	}

	function formInputCreate(form:FormElement, name:String, obj2) {
		// trace(name, obj2);
		// div wrapper with margin-bottom
		var div = document.createDivElement();
		div.classList.add('mb-3');
		form.appendChild(div);

		var id = 'input-${name}';

		// add label
		var label = document.createLabelElement();
		label.htmlFor = id;
		label.innerHTML = '${name}';
		label.classList.add("form-label");
		div.appendChild(label);
		if (Reflect.hasField(obj2, 'label')) {
			label.innerHTML = obj2.label;
		}

		// input
		var input = document.createInputElement();
		input.id = id;
		input.classList.add("form-control");
		input.dataset.inputtype = name;
		div.appendChild(input);
		switch (name.toLowerCase()) {
			case 'password':
				input.type = 'password';
			case 'email':
				input.type = 'email';
			case 'text':
				input.type = 'text';
			case 'button':
				input.type = 'submit';
				input.className = "btn btn-primary mb-3";
				div.removeChild(label); // don't need label
			case 'textarea':
				div.removeChild(input); // don't need input
				var textarea = document.createTextAreaElement();
				textarea.id = id;
				textarea.classList.add("form-control");
				textarea.dataset.inputtype = name;
				div.appendChild(textarea);
			default:
				trace("case '" + name + "': trace ('" + name + "');");
		}

		// set placeholder (if available)
		if (Reflect.hasField(obj2, 'placeholder')) {
			input.placeholder = obj2.placeholder;
		}

		// set value (if available)
		if (Reflect.hasField(obj2, 'value')) {
			input.value = obj2.value;
		}
	}

	function onSubmitHandler(e) {
		e.preventDefault();
		// trace(e);
		// trace(e.target.elements);

		var data = {};

		var form = e.target;
		for (i in Reflect.fields(formJson.form)) {
			var obj = Reflect.field(formJson.form, i);
			if (i == 'button')
				continue;
			// form.getAttribute('data-typeId');
			var let = form.querySelectorAll('[data-inputtype=${i}]')[0];
			if (let != null) {
				trace(i, let.value);
				Reflect.setField(data, i, let.value);
			}
		}
		//
		// var _cb:Dynamic = cb;
		// _cb.apply(this, null);
		Reflect.callMethod(this, cb, [e, data]);
	}
}

typedef ConfigObj = {
	@:optional var _id:String;
	var form:FormObj;
}

typedef FormObj = {
	@:optional var _id:String;
	@:optional var id:String;

	@:optional var label:String;
	// https://www.w3schools.com/html/html_form_input_types.asp
	@:optional var email:InputObj;
	@:optional var password:InputObj;
	@:optional var text:InputObj;
	@:optional var button:InputObj;
	@:optional var textarea:InputObj;
}

typedef InputObj = {
	@:optional var _id:String;
	@:optional var label:String;
	@:optional var placeholder:String;
	@:optional var value:String;
}
