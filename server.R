
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(
    function(input, output) {
            output$distPlot <- renderPlot({
                                P50<-input$FLEH[2]
                                P90<-input$FLEH[1]
                                meanFLEH<-P50
                                sdFLEH<-(P50-P90)/qnorm(0.9)
                                xseq<-seq(0,4000,50)
                                densities<-dnorm(xseq, meanFLEH,sdFLEH)
                                plot(xseq, densities, col="darkgreen",xlab="", ylab="Probability", 
                                type="l",lwd=2, cex=2, main="Probability distribution of FLEH Year 1 in MWh/MWp", cex.axis=.8)
                                abline(v=P50,col="red")
                                abline(v=P90,col="blue")
                                text(P50+300, 0, paste("P50=", P50))
                                text(P90-300, 0, paste("P90=", P90))
                                              })
            
              output$FCFPlot<- renderPlot({
                                Capacity<-input$Capacity
                                P50<-input$FLEH[2]
                                P90<-input$FLEH[1]
                                Degradation=input$Degradation/100
                                Tariff_y1=input$Tariff
                                Capex<-input$Capex*1e6*Capacity 
                                Opex<-input$Opex*Capacity 
                                Escalation<-input$Inflation_Rate/100
                                TaxRate<-input$Tax_Rate/100
                                AssetLife=input$AssetLife
                                WACC=input$WACC/100
                                
                                #Calculate annual generation with degradation and annual energy Tariff
                                Generation_P50<-Capacity*P50*(1-Degradation)^(0:(AssetLife-1))
                                Generation_P90<-Capacity*P90*(1-Degradation)^(0:(AssetLife-1))
                                Tariff<-Tariff_y1*(1+Escalation)^(0:(AssetLife-1))
                                Revenues_P50<-Generation_P50*Tariff
                                Revenues_P90<-Generation_P90*Tariff
                                
                                #Calculate EBITDA and amortisation (linear)
                                EBITDA_P50<-Revenues_P50-Opex*(1+Escalation)^(0:(AssetLife-1))
                                EBITDA_P90<-Revenues_P90-Opex*(1+Escalation)^(0:(AssetLife-1))
                                Amortisation<-rep(Capex/AssetLife)
                                Tax_P50<-(EBITDA_P50-Amortisation)*TaxRate
                                Tax_P90<-(EBITDA_P90-Amortisation)*TaxRate
                                FCF_P50<-EBITDA_P50-Tax_P50
                                FCF_P90<-EBITDA_P90-Tax_P90
                                
                                #Plot the FCF (no Capex)
                                FCF_Matrix<-rbind(FCF_P90/1e6,FCF_P50/1e6)
                                colnames(FCF_Matrix)<-seq(1:AssetLife)
                                barplot(FCF_Matrix,beside = TRUE,col=c("blue","red"),xlab="Years",ylab="MUSD",main="Free Cash Flow and Net Present Value in MUSD")
                                
                                
                                #Calculate NPV
                                NPV_P50<- (sum(FCF_P50*(1/(1+WACC))^(1:AssetLife))-Capex)/1E6
                                NPV_P90<- (sum(FCF_P90*(1/(1+WACC))^(1:AssetLife))-Capex)/1E6
                                legend("bottom", c(paste("P90-NPV=",format(NPV_P90,digits=5),"MUSD"),paste("P50-NPV=",format(NPV_P50,digits=5),"MUSD")), cex=1.3, bty="y", fill=c("blue","red"))
                                
                                })
              
              

})
