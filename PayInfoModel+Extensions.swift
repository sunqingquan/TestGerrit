//
//  PayInfoModel+Extensions.swift
//  Alamofire
//
//  Created by zhaochangwu on 2019/7/11.
//

import Foundation

enum PayTagret {

    // MARK: - 正常支付车费
    case normal

    // MARK: - 预付款流程支付余额
    case prepay

    // MARK: - 支付取消费
    case cancel
}

extension PayInfoModel {

    var payTarget: PayTagret {

        if isPrePay == true {
            return .prepay
        }

        if (cancelFee ?? 0) > 0 {
            return .cancel
        }

        return .normal
    }

    var payItems: [CostDetailCellViewModel]  {

        var cellModels: [CostDetailCellViewModel] = []

        switch payTarget {

        /// 正常支付流程
        case .normal:

            /// 费用合计
            let totalCost = CostDetailCellViewModel()
            totalCost.title = "合计费用"
            totalCost.latestValue = (totalFare?.priceString ?? "--") + "元"
            //totalCost.isShowChangedValue = actualFare != totalFare
            cellModels.append(totalCost)

            /// 动态折扣
            if let discount = discountFare, discount > 0 {
                let discountModel = CostDetailCellViewModel()
                discountModel.title = "动态折扣"
                discountModel.latestValue = "-\(discount.priceString)元"
                cellModels.append(discountModel)
            }
//
//            /// 企业支付
//            if let enterprisePayed = enterprisePayed, enterprisePayed > 0 {
//                let paid = CostDetailCellViewModel()
//                paid.title = "企业支付"
//                paid.latestValue = "-\(enterprisePayed.priceString)元"
//                cellModels.append(paid)
//            }
//
//            let paid = CostDetailCellViewModel()
//            paid.title = "企业支付"
//            paid.latestValue = "-\(10.priceString)元"
//            cellModels.append(paid)

            /// 优惠券
            if let couponPayed = couponPayed, couponPayed > 0 {
                let paid = CostDetailCellViewModel()
                paid.title = "优惠券已支付"
                paid.latestValue = "-\(couponPayed.priceString)元"
                cellModels.append(paid)
            } else {
                let coupon = CostDetailCellViewModel()
                coupon.title = "优惠券"
                coupon.isCoupon = true
                cellModels.append(coupon)
            }

            if let amountPayed = amountPayed, amountPayed > 0 {
                let paid = CostDetailCellViewModel()
                paid.title = "余额已支付"
                paid.latestValue = "-\(amountPayed.priceString)元"
                cellModels.append(paid)
            }

        /// 预付款流程
        case .prepay:

            /// 费用合计
            let totalCost = CostDetailCellViewModel()
            totalCost.title = "合计费用"
            totalCost.latestValue = (totalFare?.priceString ?? "--") + "元"
            cellModels.append(totalCost)

            /// 已预付
            let hasPrePayModel = CostDetailCellViewModel()
            hasPrePayModel.title = "已预付"
            hasPrePayModel.latestValue = (hasPrePay?.priceString ?? "") + "元"
            cellModels.append(hasPrePayModel)

            /// 企业支付
            if let enterprisePayed = enterprisePayed, enterprisePayed > 0 {
                let paid = CostDetailCellViewModel()
                paid.title = "企业支付"
                paid.latestValue = "-\(enterprisePayed.priceString)元"
                cellModels.append(paid)
            }
            
//            /// 如果预付款结算时没有使用优惠券抵扣，且当前有可使用的优惠券，则展示该项
//            if let couponPayed = couponPayed,
//                let couponCount = couponCount,
//                couponPayed == 0 && couponCount > 0 {
//                let coupon = CostDetailCellViewModel()
//                coupon.title = "优惠券"
//                coupon.isCoupon = true
//                cellModels.append(coupon)
//            }

            /// 还需支付
            let remain = CostDetailCellViewModel()
            remain.title = "还需支付"
            remain.latestValue = (actualFare?.priceString ?? "--") + "元"
            cellModels.append(remain)

        /// 支付取消费
        case .cancel:

            /// 取消费
            let cancelFeeModel = CostDetailCellViewModel()
            cancelFeeModel.title = "取消费"
            cancelFeeModel.latestValue = (cancelFee?.priceString ?? "--") + "元"
            cellModels.append(cancelFeeModel)

            /// 超时等待费为 0时，不需要展示
            if let timeOutFee = timeOutFee, timeOutFee > 0 {
                /// 超时等待费
                let timeOutFeeModel = CostDetailCellViewModel()
                timeOutFeeModel.title = "超时等待费"
                timeOutFeeModel.latestValue = (timeOutFee.priceString ?? "--") + "元"
                cellModels.append(timeOutFeeModel)

                /// 超时等待费才能使用优惠券，有超时等待费时才需要展示优惠券
                if let couponCount = couponCount, couponCount > 0 {

                    let coupon = CostDetailCellViewModel()
                    coupon.title = "优惠券"
                    coupon.isCoupon = true
                    cellModels.append(coupon)
                }
            }

            if let amountPayed = amountPayed, amountPayed > 0 {
                let paid = CostDetailCellViewModel()
                paid.title = "余额已支付"
                paid.latestValue = "-\(amountPayed.priceString)元"
                cellModels.append(paid)
            }

            /// 企业支付
            if let enterprisePayed = enterprisePayed, enterprisePayed > 0 {
                let paid = CostDetailCellViewModel()
                paid.title = "企业支付"
                paid.latestValue = "-\(enterprisePayed.priceString)元"
                cellModels.append(paid)
            }
            
//            /// 优惠券
//            if let couponPayed = couponPayed, couponPayed > 0 {
//                let paid = CostDetailCellViewModel()
//                paid.title = "优惠券已支付"
//                paid.latestValue = "-\(couponPayed.priceString)元"
//                cellModels.append(paid)
//            }
        }

        return cellModels

    }

}
