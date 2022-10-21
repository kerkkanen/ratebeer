module ApplicationHelper
  def edit_and_destroy_buttons(item)
    if current_user
      edit = button_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
      unless admin.nil?
        del = button_to('Destroy', item, method: :delete,
                                         form: { data: { turbo_confirm: "Are you sure ?" } },
                                         class: "btn btn-danger")
      end
      raw("#{edit} #{del}")
    end
  end

  def round(number)
    number_with_precision(number, precision: 1)
  end
end
