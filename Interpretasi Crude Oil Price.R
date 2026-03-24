# Untuk Statistika Deskriptif
library(psych)
library(pastecs)
# Untuk mengubah data menjadi Time Series, membuat plot ACF,
# plot PACF, Model ARIMA dan ADF Test
library(tseries)
# Untuk melihat signifikansi koefisien dari parameter
library(lmtest)
# Untuk memprediksi data dari model
library(forecast)





# 1. EDA (Explanatory Data Analysis)
## Sari Grafik
data <- read_excel("C:/Users/User/Downloads/Crude Oil Price Data.xlsx")
plot(data$'Oil Price'[1:132],main="Rata-rata Oil Price (USD) Per Bulan \n Januari 1986 - Desember 1996",ylab="Rata-rata Per Bulan (USD)",xlab="Bulan ke-",type='o')

# Membuat garis rataan
abline(h=mean(data$`Oil Price`),lwd=2, lty = 2, col ='red')

# Boxplot
boxplot(data$'Oil Price'[1:132], horizontal=F ,main="Rata-rata Oil Price (USD) Per Bulan \n Januari 1986 - Desember 1996")

## Sari Numerik
summary(data$'Oil Price'[1:132])
describe(data$'Oil Price'[1:132])
stat.desc(data$'Oil Price'[1:132])

## Mengubah ke data time series
ts_data <- ts(data$'Oil Price'[1:132])

## Plot ACF dan PACF awal
acf(data$'Oil Price'[1:132], main = "Grafik ACF Data", lag.max = 36)
pacf(data$'Oil Price'[1:132], main = "Grafik PACF Data", lag.max = 36)
#Dari ACF terlihat bahwa data belum stasioner karena masih signifikan di lag yang tinggi.





# 2. IDENTIFIKASI MODEL
## Uji ADF
adf.test(ts_data)
#Uji ADF menunjukkan data tidak stasioner.  

## Diferensi
data_diff <- diff(ts_data)
adf.test(data_diff)
#Setelah didiferensi 1 kali, uji ADF menunjukkan data sudah stasioner.  

#Grafik data setelah didiferensi 1 kali:
plot(data_diff, lwd = 2, main = 'Plot Data Diferensiasi 1 Kali ', 
     xlab = "Waktu", ylab = "Nilai Diferensiasi Data")
abline(h=mean(data_diff), lwd=2,lty = 2, col ='red')


## Plot ACF & PACF
acf(data_diff, main = "Grafik ACF Data Diferensiasi", lag.max = 36)
pacf(data_diff, main = "Grafik PACF Data Diferensiasi", lag.max = 36)
#Grafik ACF dan PACF cut off di lag kedua. Oleh karenanya, kandidat model yang dipilih:  
#1.ARIMA(1,1,2)
#2.ARIMA(0,1,2)
#3.ARIMA(2,1,0)





# 3. ESTIMASI PARAMETER
## Model ARIMA(1,1,2)
mod_1 <- arima(ts_data, order = c(1, 1, 2))
mod_1
## Model ARIMA(0,1,2)
mod_2 <- arima(ts_data, order = c(0, 1, 2))
mod_2
## Model ARIMA(2,1,0)
mod_3 <- arima(ts_data, order = c(2, 1, 0))
mod_3
#Terlihat bahwa model 1, yaitu ARIMA(1,1,2), memiliki AIC paling kecil. 


## Signifikansi Parameter
# Model 1
coeftest(mod_1)
# Model 2
coeftest(mod_2)
# Model 3
coeftest(mod_3)


#Semua parameter pada model otomatis signifikan. Model terbaik dipilih berdasarkan kriteria:  
#1. AIC terkecil  
#2. Parameter signifikan  
#3. Parsimoni  

#Model 1 memenuhi ketiga kriteria tersebut sehingga ARIMA(1,1,2) dipilih sebagai model terbaik.





# 4. UJI DIAGNOSTIK
checkresiduals(mod_1)
#Asumsi galat normal, saling bebas, dan variansi homogen (homoskedastis) terpenuhi. Uji Ljung-Box menunjukkan model ARIMA(1,1,2) cocok untuk memodelkan data.





#5. FORECAST
#Prediksi 1 tahun ke depan
data_aktual <- data$'Oil Price'[133:144]

## Model 1, ARIMA(1,1,2) -> TERBAIK
fc_mod1 <- forecast(ts_data, model = mod_1, h = 12)
summary(fc_mod1)
## Model 2, ARIMA(0,1,2)
fc_mod2 <- forecast(ts_data, model = mod_2, h = 12)
summary(fc_mod2)
## Model 3, ARIMA(2,1,0)
fc_mod3 <- forecast(ts_data, model = mod_3, h = 12)
summary(fc_mod3)

# Plot hasil peramalan vs data aktual
## Model 1
plot(fc_mod1, main = "Hasil Peramalan vs Data Aktual \n ARIMA(1,1,2)", xlab= "Waktu (Bulan ke-)", ylab="Harga Minyak (USD)")
lines(133:144, data_aktual, col = "red", lwd = 2)
legend("topleft", legend = c("Ramalan", "Data Aktual"), col = c("blue", "red"), lty = 1, lwd = 2)
## Model 2
plot(fc_mod2, main = "Hasil Peramalan vs Data Aktual\n ARIMA(0,1,2)", xlab= "Waktu (Bulan ke-)", ylab="Harga Minyak (USD)")
lines(133:144, data_aktual, col = "red", lwd = 2)
legend("topleft", legend = c("Ramalan", "Data Aktual"), col = c("blue", "red"), lty = 1, lwd = 2)
## Model 3
plot(fc_mod3, main = "Hasil Peramalan vs Data Aktual\n ARIMA(2,1,0)", xlab= "Waktu (Bulan ke-)", ylab="Harga Minyak (USD)")
lines(133:144, data_aktual, col = "red", lwd = 2)
legend("topleft", legend = c("Ramalan", "Data Aktual"), col = c("blue", "red"), lty = 1, lwd = 2)

#Penilaian Akurasi Dari Model Terbaik
akurasi <- accuracy(fc_mod1, data_aktual)
print(akurasi)

#Buat Tabel Perbandingan Akurasi
akurasi_mod1 <- accuracy(fc_mod1, data_aktual)
akurasi_mod2 <- accuracy(fc_mod2, data_aktual)
akurasi_mod3 <- accuracy(fc_mod3, data_aktual)
# Kita hanya fokus pada metrik di 'Test set'
tabel_perbandingan <- rbind(
  ARIMA_112 = akurasi_mod1[2,],
  ARIMA_012 = akurasi_mod2[2,],
  ARIMA_210 = akurasi_mod3[2,])

print(tabel_perbandingan)
