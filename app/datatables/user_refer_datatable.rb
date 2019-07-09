class UserReferDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "UserRefer.id", cond: :eq },
      name: { source: "User.name", cond: :like },
      mobile: { source: "User.mobile", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        name: record.down_user.name,
        mobile: record.down_user.mobile,
        user_id: record.down_user_id
      }
    end
  end

  private

  def get_raw_records
    UserRefer.where(user: params[:id], level: params[:level])
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
