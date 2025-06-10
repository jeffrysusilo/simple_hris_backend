class EmployeesController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin

  def index
    employees = User.where(role: "employee")
    render json: employees
  end

  def show
    employee = User.find_by(id: params[:id], role: "employee")
    if employee
      render json: employee
    else
      render json: { error: "Karyawan tidak ditemukan" }, status: :not_found
    end
  end

  def create
    employee = User.new(employee_params.merge(role: "employee"))
    if employee.save
      render json: employee, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    employee = User.find_by(id: params[:id], role: "employee")
    if employee&.update(employee_params)
      render json: employee
    else
      render json: { error: "Update gagal" }, status: :unprocessable_entity
    end
  end

  def destroy
    employee = User.find_by(id: params[:id], role: "employee")
    if employee&.destroy
      render json: { message: "Karyawan dihapus" }
    else
      render json: { error: "Gagal hapus karyawan" }, status: :unprocessable_entity
    end
  end

  private

  def employee_params
    params.require(:user).permit(:name, :email, :password)
    end

end
