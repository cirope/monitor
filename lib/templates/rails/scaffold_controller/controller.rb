# frozen_string_literal: true

<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :authorize
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all class_name %>
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build class_name %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build class_name, "#{singular_table_name}_params" %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= singular_table_name %>.update <%= "#{singular_table_name}_params" %>
      redirect_to @<%= singular_table_name %>
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>

    redirect_to <%= plural_table_name %>_url
  end

  private

    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find class_name, 'params[:id]' %>
    end

    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit <%= attributes_names.map { |name| ":#{name}" }.join(', ') %>
      <%- end -%>
    end
end
<% end -%>
