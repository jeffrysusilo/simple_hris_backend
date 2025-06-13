class EmployeesController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin

  def index
    employees = User.includes(:employee).where(role: "employee")
    
    data = employees.map do |user|
      {
        id: user.id,
        name: user.name,
        email: user.email,
        position: user.employee&.position || "Belum di-assign"
      }
    end

    render json: data
  end


  def show
    user = User.find_by(id: params[:id], role: "employee")
    if user && user.employee
      render json: {
        id: user.id,
        name: user.name,
        email: user.email,
        position: user.employee.position
      }
    else
      render json: { error: "Karyawan tidak ditemukan atau belum di-assign" }, status: :not_found
    end
  end


  # def create
  #   employee = User.new(employee_params.merge(role: "employee"))
  #   if employee.save
  #     render json: employee, status: :created
  #   else
  #     render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def employee_params
    params.require(:employee).permit(:user_id, :position)
  end

  # def create
  #   employee = Employee.new(employee_params)

  #   if employee.save
  #     render json: { message: 'Employee assigned successfully.', data: employee }, status: :created
  #   else
  #     render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def create
    user = User.find_by(id: employee_params[:user_id], role: "employee")
    
    unless user
      return render json: { error: "User not found or is not an employee" }, status: :not_found
    end

    employee = Employee.new(user: user, position: employee_params[:position])

    if employee.save
      render json: { message: 'Employee assigned successfully.', data: employee }, status: :created
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

  # def employee_params
  #   params.require(:user).permit(:name, :email, :password)
  #   end

end
