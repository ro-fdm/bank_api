require "rails_helper"

describe Transfer do
  let(:user) { create(:user) }
  let(:bank) { FactoryBot.create(:bank) }
  let(:origin_account){ FactoryBot.create(:bank_account, bank: bank, balance: 1500) }
  let(:destination_account) { FactoryBot.create(:bank_account, bank: bank, balance: 1000) }
  let(:payment_intra_bank){ FactoryBot.create(:payment,
                                              amount: 100,
                                              origin: origin_account,
                                              destination: destination_account,
                                              kind: "transfer" )}

  let(:bank2) { FactoryBot.create(:bank) }
  let(:destination_account_different_bank){ FactoryBot.create(:bank_account, bank: bank2, balance: 1000) }
  let(:payment_inter_bank){ FactoryBot.create(:payment,
                                              amount: 100,
                                              origin: origin_account,
                                              destination: destination_account_different_bank,
                                              kind: "transfer" )}

  it "transfer intra bank" do
    transfer = payment_intra_bank.payment_service
    result = transfer.new(payment_intra_bank).run!

    expect(result).to be_truthy
    expect(payment_intra_bank.comision).to eq(0)
    expect(payment_intra_bank.origin.balance).to eq(1400)
    expect(payment_intra_bank.destination.balance).to eq(1100)
  end

  it "transfer inter bank" do
    transfer = payment_inter_bank.payment_service
    result = transfer.new(payment_inter_bank).run!

    expect(result).to be_truthy
    expect(payment_inter_bank.comision).to eq(500)
    expect(payment_inter_bank.origin.balance).to eq(900)
    expect(payment_inter_bank.destination.balance).to eq(1100)
  end

  it "transfer inter bank fails by exceed limit" do
    payment = FactoryBot.create(:payment,
                                  amount: 100001,
                                  origin: origin_account,
                                  destination: destination_account_different_bank,
                                  kind: "transfer" )
    transfer = payment.payment_service
    result = transfer.new(payment).run!

    expect(result).to be_falsey
    expect(payment.comision).to eq(nil)
    expect(payment.origin.balance).to eq(1500)
    expect(payment.destination.balance).to eq(1000)
  end

end
