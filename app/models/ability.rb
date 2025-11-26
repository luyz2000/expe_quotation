# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted? && user.admin?
      # Administrator: Full CRUD and approve/reject quotations
      can :manage, :all
      can :approve, Quotation
      can :reject, Quotation
    elsif user.persisted? && user.salesperson?
      # Salesperson: Create and manage their own quotations and clients
      can :read, User, id: user.id
      can :update, User, id: user.id
      can :create, Client
      can :read, Client
      can :update, Client
      can :create, Project
      can :read, Project do |project|
        project.responsible_id == user.id
      end
      can :update, Project do |project|
        project.responsible_id == user.id
      end
      can :create, Quotation
      can :read, Quotation do |quotation|
        quotation.salesperson_id == user.id
      end
      can :update, Quotation do |quotation|
        quotation.salesperson_id == user.id
      end
      can :send_for_approval, Quotation do |quotation|
        quotation.salesperson_id == user.id
      end
      can :create, QuotationItem
      can :update, QuotationItem do |item|
        item.quotation.salesperson_id == user.id
      end
      can :destroy, QuotationItem do |item|
        item.quotation.salesperson_id == user.id
      end
      can :read, Material
      can :create, Material
      can :update, Material
      can :read, Service
      can :create, Service
      can :update, Service
      can :view_own, :reports
    elsif user.persisted? && user.engineer?
      # Engineer: Supervise assigned projects and quotations
      can :read, User, id: user.id
      can :update, User, id: user.id
      can :read, Client
      can :create, Project
      can :read, Project do |project|
        project.responsible_id == user.id
      end
      can :update, Project do |project|
        project.responsible_id == user.id
      end
      can :create, Quotation
      can :read, Quotation do |quotation|
        quotation.project.responsible_id == user.id rescue false
      end
      can :update, Quotation do |quotation|
        quotation.project.responsible_id == user.id rescue false
      end
      can :send_for_approval, Quotation do |quotation|
        quotation.project.responsible_id == user.id rescue false
      end
      can :create, QuotationItem
      can :update, QuotationItem do |item|
        item.quotation.project.responsible_id == user.id rescue false
      end
      can :destroy, QuotationItem do |item|
        item.quotation.project.responsible_id == user.id rescue false
      end
      can :read, Material
      can :create, Material
      can :update, Material
      can :read, Service
      can :create, Service
      can :update, Service
      can :view_own, :reports
    else
      # Unauthenticated user
      can :read, :all
    end
  end
end
