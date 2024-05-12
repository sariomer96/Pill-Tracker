//
//  SelectedDaysViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation

class SelectedDaysViewModel: ReminderData {
    static let shared = SelectedDaysViewModel()
    var reminder: Reminder?
    let maxTimeCountLimit = 3 //
    var callBackMaxLimit:CallBack<Int>?
    var callBackAddTime:CallBack<Int>?
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
      
    }
    
    func CheckMaxTimeCount(rowCount: Int, row: Int) {
        if maxTimeCountLimit + 1 == rowCount {
            callBackMaxLimit?(row)
        } else {
            //callBackMaxLimit?(false)
            callBackAddTime?(row)
        }
        
//        
//        if !maxLimit {
//            addNewTime(tableView: tableView, indexPath: indexPath)
//        } else if indexPath.row == lastRowIndex-1{
//            alert(title: "Max LIMIT", message: "MAX SAYIYA ULASTIN")
//        }
    }

    
}
