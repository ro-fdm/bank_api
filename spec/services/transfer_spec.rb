require "rails_helper"

describe Transfer do
  let(:user) { create(:user) }
  let(:bank) { FactoryBot.create(:bank) }
  let(:origin_account){ FactoryBot.create(:bank_account, bank: bank, balance: 15) }
  let(:destination_account) { FactoryBot.create(:bank_account, bank: bank, balance: 10) }
  let(:payment_intra_bank){ FactoryBot.create(:payment,
                                              amount: 1,
                                              origin: origin_account,
                                              destination: destination_account,
                                              kind: "transfer" )}

  let(:bank2) { FactoryBot.create(:bank) }
  let(:destination_account_different_bank){ FactoryBot.create(:bank_account, bank: bank2, balance: 10) }
  let(:payment_inter_bank){ FactoryBot.create(:payment,
                                              amount: 1,
                                              origin: origin_account,
                                              destination: destination_account_different_bank,
                                              kind: "transfer" )}

  it "transfer intra bank" do
    transfer = payment_intra_bank.payment_service
    result = transfer.new(payment_intra_bank).run!

    expect(result).to be_truthy
    expect(payment_intra_bank.comision).to eq(0)
    expect(payment_intra_bank.origin.balance).to eq(14)
    expect(payment_intra_bank.destination.balance).to eq(11)
  end

  it "transfer inter bank" do
    transfer = payment_inter_bank.payment_service
    result = transfer.new(payment_inter_bank).run!

    expect(result).to be_truthy
    expect(payment_inter_bank.comision).to eq(5)
    expect(payment_inter_bank.origin.balance).to eq(9)
    expect(payment_inter_bank.destination.balance).to eq(11)
  end

end
