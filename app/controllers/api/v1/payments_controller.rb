module Api::V1
  class PaymentsController < ApplicationController
    def show
      @payment = Payment.find(params[:id])
      json_response(@payment)
    end

    def create
      @payment = Payment.create!(payment_params)
      if @payment.kind
        service = @payment.payment_service
        service.new(@payment).run!
      end

      render json: @payment, serializer: PaymentSerializer, status: :created
    end

    private

    def payment_params
      params.require(:payment).permit(:amount, :origin_id, :destination_id, :kind)
    end
  end
end
