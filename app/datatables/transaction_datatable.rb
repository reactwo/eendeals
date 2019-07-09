class TransactionDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
        id: { source: 'Transaction.id', cond: :eq },
        amount: { source: 'Transaction.amount', cond: false },
        category: { source: 'Transaction.category', cond: false },
        direction: { source: 'Transaction.direction', cond: false },
        from_user_id: { source: 'Transaction.from_user_id', cond: false },
        user_id: { source: 'Transaction.user_id', cond: false },
        user_name: { source: 'Transactions.user.name', cond: false },
        data: { source: 'Transaction.data', cond: false },
        created_at: { source: 'Transaction.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
          # example:
          id: record.id,
          amount: record.amount,
          category: Transaction::CATEGORY_REVERSE[record.category],
          direction: Transaction::DIRECTION_REVERSE[record.direction],
          from_user_id: record.from_user_id,
          user_id: record.user_id,
          data: record.data,
          from_user_name: record.from_user_id ? record.from_user.name : '',
          user_name: record.user.name,
          created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    if params[:type] and params[:id]
      status = params[:type] === 'active' ? User::STATUS[:approved] : User::STATUS[:verified]
      Transaction.where(user_id: params[:id], from_user_status: status)
    else
      Transaction.all
    end
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
