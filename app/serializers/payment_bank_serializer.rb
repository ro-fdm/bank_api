class PaymentBankSerializer < ActiveModel::Serializer
  attributes :id,
             :amount,
             :comision,
             :status
end
