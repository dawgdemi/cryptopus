# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class Admin::MaintenanceTasksController < Admin::AdminController

  # GET /admin/maintenance_tasks
  def index
    @maintenance_tasks = MaintenanceTask.list
    @maintenance_logs = Log.where(log_type: 'maintenance_task')
  end

  # GET /admin/maintenance_tasks/1/prepare
  def prepare
    task = MaintenanceTask.tasks[params[:id].to_i]
    @maintenance_task = MaintenanceTask.constantize_class(task)
    flash[:notice] = @maintenance_task.hint
  end

  # POST /admin/maintenance_tasks/1/execute
  def execute
    param_values = { private_key: session[:private_key] }

    param_values.merge!(task_params)
    task = MaintenanceTask.initialize_task(params[:id], current_user, param_values)

    if task.execute
      flash[:notice] = t('flashes.admin.maintenance_tasks.succeed')
    else
      flash[:error] = t('flashes.admin.maintenance_tasks.failed')
    end
    redirect_to admin_maintenance_tasks_path
  end

  private

  def task_params
    params.require(:task_params).
      permit(:new_root_password, :retype_password, :root_password)
  end

end
