class UserDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: {source: 'User.id', cond: :start_with },
      name: {source: 'User.name', cond: :start_with },
      mobile: { source: 'User.mobile', cond: :start_with },
      direct: { source: 'User.real_sponsor.name', cond: false },
      sponsor: { source: 'User.real_sponsor.name', cond: false },
      doj: { source: 'User.created_at', cond: false },
      wallet: { source: 'User.Wallet.active', cond: false },
      refer_id: { source: 'User.refer_id', cond: :start_with }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        mobile: record.mobile,
        direct: record.real_sponsor ? record.real_sponsor.name : '',
        direct_id: record.real_sponsor ? record.real_sponsor.id : '',
        sponsor: record.sponsor ? record.sponsor.name : '',
        sponsor_id: record.sponsor ? record.sponsor.id : '',
        doj: record.created_at.strftime('%d-%m-%Y'),
        wallet: record.wallet ? "A - #{record.wallet.active}/P - #{record.wallet.passive}/R - #{record.wallet.redeem}" : "NA",
        refer_id: record.refer_id
      }
    end
  end

  private

  def get_raw_records
    User.all
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
