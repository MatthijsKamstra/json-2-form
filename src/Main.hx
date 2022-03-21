package;

import utils.UUID;
import js.Browser.*;
import js.Browser;
import js.html.*;
import model.constants.App;

/**
 * @author Matthijs Kamstra aka [mck]
 * MIT
 *
 */
class Main {
	var container:js.html.DivElement;

	var formJson:ConfigObj = {
		form: {
			email: {label: "E-mail", placeholder: "foo@bar.nl"},
			password: {label: "Password (pass)"},
			text: {},
			button: {value: "Submit"}
		}
	}

	public function new() {
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${App.NAME} Dom ready :: build: ${App.getBuildDate()} ');
			initHTML();
			// loadData();
		});
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
		trace(e);
		trace(e.target.elements);
		var form = e.target;
		for (i in Reflect.fields(formJson.form)) {
			var obj = Reflect.field(formJson.form, i);
			if (i == 'button')
				continue;

			// form.getAttribute('data-typeId');
			var let = form.querySelectorAll('[data-inputtype=${i}]')[0];
			trace(i, let.value);
		}
	}

	function initHTML() {
		container = cast document.getElementById('js-gen-form');

		var form = document.createFormElement();
		form.id = UUID.uuid();
		form.name = 'x';
		form.onsubmit = onSubmitHandler;
		for (i in Reflect.fields(formJson.form)) {
			var obj = Reflect.field(formJson.form, i);
			formInputCreate(form, i, obj);
		}

		container.appendChild(form);
	}

	function loadData() {
		var url = 'http://ip.jsontest.com/';
		var req = new haxe.Http(url);
		// req.setHeader('Content-Type', 'application/json');
		// req.setHeader('auth', '${App.TOKEN}');
		req.onData = function(data:String) {
			try {
				var json = haxe.Json.parse(data);
				trace(json);
			} catch (e:Dynamic) {
				trace(e);
			}
		}
		req.onError = function(error:String) {
			trace('error: $error');
		}
		req.onStatus = function(status:Int) {
			trace('status: $status');
		}
		req.request(true); // false=GET, true=POST
	}

	static public function main() {
		var app = new Main();
	}
}

typedef ConfigObj = {
	@:optional var _id:String;
	var form:{};
	// var data:ConfigDataObj;
	// var structure:ConfigStructureObj;
}
