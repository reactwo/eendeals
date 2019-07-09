class RedeemDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
        id: { source: 'Redeem.id', cond: :eq },
        coins: { source: 'Redeem.coins', cond: :eq },
        kind: { source: 'Redeem.kind', cond: :eq },
        user: { source: 'Redeem.user.name', cond: false },
        status: { source: 'Redeem.status', cond: :eq },
        created_at: { source: 'Redeem.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
          id: record.id,
          coins: record.coins,
          kind: Redeem::KIND_REVERSE[record.kind],
          user_id: record.user_id,
          user_name: record.user.name,
          status: Redeem::STATUS_REVERSE[record.status],
          created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    if params[:id]
      User.find_by_id(params[:id]).redeems
    else
      Redeem.all
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
