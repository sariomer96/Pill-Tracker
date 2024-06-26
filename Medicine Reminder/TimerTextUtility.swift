 
import Foundation

class TimerTextUtility {
    static let shared = TimerTextUtility()
    
  let day = "Gün"
  let hour = "Saat"
  let minute = "Dk."
  let remainingSeconds = "Saniye Kaldı"
  let timerAlert = "Lütfen saat ve gün bilgisi ekleyin"
  let notFoundHour = "Hour Not Found"
  let notFoundFutureHour = "Gelecek saat bulunamadı"
  let pillTime = "İlaç Saati"
  let invalidTimeFormat = "Invalid time format:"
}
 
class AlertText {
    static let shared = AlertText()
    
    let alertTitle = "UYARI"
    let alertMaxMessage = "Daha fazla oluşturulamaz."
    let unsavedMessage = "Kaydedilmeyen veriler kaybolacak. Çıkmak istediğinizden emin misiniz?"
    let no = "Hayır"
    let yes = "Evet"
   
    
}

class ActionText {
    static let shared = ActionText()
    
    let delete = "Sil"
    let deleteAlert = "Hatırlatıcıyı kaldırmak istediğinizden emin misiniz?"
    let cancel = "İptal"
}
