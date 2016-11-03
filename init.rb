Redmine::Plugin.register :redmine_improve do
  name 'Redmine Improve plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

require 'issue_patch'

class Hooks < Redmine::Hook::ViewListener
  # This just renders the partial in
  # app/views/hooks/my_plugin/_view_issues_form_details_bottom.rhtml
  # The contents of the context hash is made available as local variables to the partial.
  #
  # Additional context fields
  #   :issue  => the issue this is edited
  #   :f      => the form object to create additional fields

  render_on :view_issues_form_details_bottom, :partial=> 'issues/check_box_close'
  render_on :view_issues_show_extra_details_bottom, :partial=> 'issues/show_details'

  def controller_issues_edit_after_save(context={})
    params = context[:params]
    issue = context[:issue]
    if issue.status.is_closed?
      if params[:close_parent_issue]
        issue.parent.update(status_id: issue.status_id)
      end
    end
  end
end
