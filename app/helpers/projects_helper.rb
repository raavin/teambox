module ProjectsHelper

  def list_people_statuses(people)
    render :partial => 'people/person', :collection => people
  end
  
  def list_projects(projects)
    render :partial => 'projects/project', :collection => projects
  end
  
  def project_link(project)
    link_to h(project.name), project_path(project)
  end
  
  def new_project_link
    link_to content_tag(:span, t('.new_project')), new_project_path, :class => 'button'
  end

  def project_fields(f,project)
    render :partial => 'fields', 
      :locals => { 
        :f => f,
        :project => project }
  end
  
  def list_pending_projects(invitations)
    render :partial => 'projects/pending', :as => :invitation, :collection => invitations
  end
  
end