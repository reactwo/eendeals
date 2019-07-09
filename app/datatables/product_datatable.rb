class ProductDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "Product.id", cond: :eq },
      name: { source: "Product.name", cond: :like },
      price: { source: 'Product.price', cond: :eq },
      link: { source: 'Product.link', cond: :eq },
      created_at: { source: 'Product.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        price: record.price,
        link: record.link,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Product.all
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
