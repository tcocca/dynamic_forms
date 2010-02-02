function add_field(container_id, association, content) {
  $(container_id).insert(new_content_id(association, content));
  
  // Get all the hidden position fields in the div.form_field_options above the link
  // Find the max value
  // Cycle through all the hidden position fields that are blank and update the value
  var position_fields = $(container_id).getElementsBySelector(".field_position");
  var max_position = position_fields.max(function(n) { return n.value});
  if(max_position == "") {
    max_position = 1;
  }
  var blank_positions = position_fields.findAll(function(n) { return n.value == ""});
  blank_positions.each(function(n) {
    max_position = parseInt(max_position) + 1;
    n.value = max_position;
  });
}

function add_field_option(link, association, content) {
  $(link).up().insert({
    before: new_content_id(association, content)
  });
  
  // Get all the hidden position fields in the div.form_field_options above the link
  // Find the max value
  // Cycle through all the hidden position fields that are blank and update the value
  var parent_container = $(link).up(".form_field_options");
  var position_fields = parent_container.getElementsBySelector(".field_option_position");
  var max_position = position_fields.max(function(n) { return n.value});
  var blank_positions = position_fields.findAll(function(n) { return n.value == ""});
  blank_positions.each(function(n) {
    max_position = parseInt(max_position) + 1;
    n.value = max_position;
  });
}

function new_content_id(association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  return content.replace(regexp, new_id);
}

function remove_field(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up('.field').hide();
  
  // Get the position element for the field that is being removed and get the value
  // Remove the position element from the DOM
  // Get the parent container of the form field
  // Cycle through the the hidden position elements and if the value is greater than the value that was removed, decrement by 1
  var position = $(link).up('.field').getElementsBySelector('.field_position').first();
  var position_value = position.value;
  position.remove();
  var parent_container = $('form_fields');
  parent_container.getElementsBySelector(".field_position").each(function(n) {
    if(parseInt(n.value) > position_value) {
      var pos = parseInt(n.value) - 1;
      n.value = pos;
    }
  });
}

function remove_field_option(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up('.option').hide();
  
  // Get the position element for the option that is being removed and get the value
  // Remove the position element from the DOM
  // Get the parent container of the form field options
  // Cycle through the the hidden position elements and if the value is greater than the value that was removed, decrement by 1
  var position = $(link).up().previous("input[type=hidden]");
  var position_value = position.value;
  position.remove();
  var parent_container = $(link).up(".form_field_options");
  parent_container.getElementsBySelector(".field_option_position").each(function(n) {
    if(parseInt(n.value) > position_value) {
      var pos = parseInt(n.value) - 1;
      n.value = pos;
    }
  });
}
