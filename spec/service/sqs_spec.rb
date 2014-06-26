require 'spec_helper'

describe Alephant::Harness::Service::SQS do

  let(:queue_name) { "queue" }
  let(:queues) { double("AWS::SQS::QueueCollection") }
  let(:queue)  { double("AWS::SQS::Queue") }

  describe ".create" do
    it "creates a new queue" do
      allow(queues).to receive(:create).with(queue_name)

      expect_any_instance_of(AWS::SQS).to receive(:queues).and_return(queues)
      subject.create queue_name
    end
  end

  describe ".delete" do
    it "deletes a queue" do
      allow_any_instance_of(AWS::SQS).to receive(:queues).and_return(queues)

      allow(queues).to receive(:named).and_return(queue)

      expect(queue).to receive(:delete)
      subject.delete queue_name
    end
  end

  describe ".get" do
    it "gets a queue" do
      allow_any_instance_of(AWS::SQS).to receive(:queues).and_return(queues)
      allow(queues).to receive(:named).with(queue_name).and_return(queue)

      expect(subject.get queue_name).to eq(queue)
    end
  end

  describe ".exists?" do
    context "when queue exists" do
      it "yields control" do
        allow_any_instance_of(AWS::SQS).to receive(:queues).and_return(queues)
        allow(queues).to receive(:named).with(queue_name).and_return(queue)

        expect { |b| subject.exists?(queue_name, &b) }.to yield_control
      end
    end

    context "when queue does not exist" do
      it "does not yield control" do
        allow_any_instance_of(AWS::SQS).to receive(:queues).and_return(queues)
        allow(queues).to receive(:named).with(queue_name).and_return(nil)

        expect { |b| subject.exists?(queue_name, &b) }.to_not yield_control
      end
    end
  end

end