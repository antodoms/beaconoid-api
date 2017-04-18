class Api::V1::AdvertisementsController < ApplicationController
	class AdvertisementNotFound < StandardError; end
	class BeaconNotFound < StandardError; end

	def index
		begin
			if params[:email].present? && params[:beacon_id].present?
				customer = Customer.find_or_create_by(:email => params[:email])
				beacon = Beacon.find_by(:unique_reference => params[:beacon_id])
				if !beacon.present?
					raise BeaconNotFound
				end
				advertisements = beacon.advertisements
				
				CustomerTracking.create(customer_id: customer.id, category_id: advertisements.pluck(:category_id), store_id: beacon.store_id, advertisement_id: advertisements.pluck(:id), beacon_id: beacon.id, action: "fetch", time: Time.now)
				#binding.pry

				render json: modify(advertisements)
			elsif params[:email].present? && params[:advertisement_id].present?
				customer = Customer.find_or_create_by(:email => params[:email])
				advertisement = Advertisement.find_by(id: params[:advertisement_id])
				if !advertisement.present?
					raise AdvertisementNotFound
				end

				beacon = advertisement.beacon

				CustomerTracking.create(customer_id: customer.id, category_id: [advertisement.category_id], store_id: beacon.store_id, advertisement_id: [advertisement.id], beacon_id: beacon.id, action: "click", time: Time.now)

				render json: {status: :success}
			else
				#binding.pry
				render json: {status: :failed, reason: "please pass the right parameters"}
			end
		rescue BeaconNotFound
			render json: {status: :failed, reason: "beacon not found"}
		rescue AdvertisementNotFound
			render json: {status: :failed, reason: "advertisement not found"}
		end
	end

	def modify(ad)
		{
			:status => :success,
			:advertisements => ad
		}

	end
end
