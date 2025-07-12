// app/javascript/controllers/chat_type_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["privateRadio", "groupRadio", "privateFields", "groupFields"]

  connect() {
    this.toggleFields()
    
  }

  toggleFields() {
    if (this.privateRadioTarget.checked) {
      this.privateFieldsTarget.classList.remove("hidden")
      this.groupFieldsTarget.classList.add("hidden")
    } else {
      this.privateFieldsTarget.classList.add("hidden")
      this.groupFieldsTarget.classList.remove("hidden")
    }
  }

  change() {
    this.toggleFields()
  }
}
