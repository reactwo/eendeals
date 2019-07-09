class Admin::ConversionsController < ApplicationController

  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: ConversionDatatable.new(view_context) }
    end
  end

  def show
  end

  def approve
    Conversion.transaction do
      conversion = Conversion.find_by_id params[:id]

      if conversion
        transaction = Transaction.new(
            category: Transaction::CATEGORY[conversion.company.downcase().to_sym],
            direction: Transaction::DIRECTION[:credit],
            user_id: conversion.user_id,
            from_user_id: conversion.user_id,
            from_user_status: conversion.user.status,
            data: "{offer_id: #{conversion.offer_id}}",
            amount: conversion.offer.amount
        )
        if transaction.save
          transaction.user.wallet.add_money transaction.amount
          conversion.update(status: Conversion::STATUS[:approved])
          flash[:success] = 'Conversion credited'
        else
          flash[:error] = 'There was some error'
        end
      end
      redirect_back fallback_location: admin_conversions_path
    end
  end

end
