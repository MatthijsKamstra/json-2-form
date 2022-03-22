package;

import js.Browser.*;
import model.constants.App;

/**
 * @author Matthijs Kamstra aka [mck]
 */
class Main {
	var formJson:Json2Form.ConfigObj = {
		form: {
			email: {label: "E-mail", placeholder: "foo@bar.nl"},
			password: {label: "Password (pass)"},
			text: {},
			button: {value: "Submit"},
			id: 'xxxxx-xxxx',
		}
	}
	var formJson2:Json2Form.ConfigObj = {
		form: {
			text: {label: 'What do you need?', placeholder: 'I need...'},
			textarea: {label: 'Tell me more'},
			button: {value: "Submit2"},
			id: 'yyyyy-yyyyyy',
		}
	}

	public function new() {
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${App.NAME} Dom ready :: build: ${App.getBuildDate()} ');
			initHTML();
			// loadData();
		});
	}

	function onSubmitHandler(e, data) {
		e.preventDefault();
		trace(e);
		trace(data);
	}

	function onSubmitHandler2(e, data) {
		e.preventDefault();
		trace(e);
		trace(data);
	}

	function initHTML() {
		var jForm = Json2Form.create('#js-gen-form', formJson, onSubmitHandler);
		var jForm = Json2Form.create('#js-gen-form2', formJson2, onSubmitHandler2);
	}

	static public function main() {
		var app = new Main();
	}
}
