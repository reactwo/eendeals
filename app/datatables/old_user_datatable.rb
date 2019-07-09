class OldUserDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: {source: 'OldUser.id', cond: :eq },
      email: {source: 'OldUser.email', cond: :eq },
      mobile: {source: 'OldUser.mobile', cond: :eq },
      name: {source: 'OldUser.name', cond: :start_with },
      refer_id: {source: 'OldUser.refer_id', cond: :eq },
      sponsor_id: {source: 'OldUser.sponsor_id', cond: :eq },
      real_sponsor_id: {source: 'OldUser.real_sponsor_id', cond: :eq },
      created_at: { source: 'OldUser.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        email: record.email,
        mobile: record.mobile,
        name: record.name,
        refer_id: record.refer_id,
        sponsor_id: record.sponsor_id,
        real_sponsor_id: record.real_sponsor_id,
        created_at: record.created_at
      }
    end
  end

  private

  def get_raw_records
    OldUser.all.order(id: :desc)
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
