class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :comision, :kind

  belongs_to :origin, serializer: BankAccountPaymentSerializer

  belongs_to :destination, serializer: BankAccountPaymentSerializer
end
