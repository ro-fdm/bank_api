class BankAccountPaymentSerializer < ActiveModel::Serializer
  attributes :id, :iban, :balance
end