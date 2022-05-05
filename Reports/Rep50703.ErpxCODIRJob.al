report 50703 "Erpx CODIR Job"
{
    Caption = 'CODIR Job';
    RDLCLayout = './Reports/CODIRprojets.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            column(No; "No.")
            {
            }
            column(ShowDoutaz; ShowDoutaz)
            { }
            column(ShowDASA; ShowDASA)
            { }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(Abbreviation; Abbreviation)
            {
            }
            column(ErpxJobCity; "Erpx Job City")
            {
            }
            column(ERPXProjectManager; "ERPX Project Manager")
            {
            }
            column(ErpxGeneralExpensesFees; "Erpx % General Expenses Fees")
            {
            }
            column(ErpxDesiredBenefit; "Erpx % Desired Benefit")
            {
            }
            column(ErpxHourlyFeesAvailable; "Erpx Hourly Fees Available")
            {
            }
            column(ErpxHourlyFeesUsed; "Erpx Hourly Fees Used")
            {
            }
            column(ErpxHourfeesBalDisposal; "Erpx Hour fees Bal. Disposal")
            {
            }
            column(Erpxinvoiced; "Erpx % invoiced")
            {
            }
            column(ErpxAmountinvoicedHT; "Erpx Amount invoiced HT")
            {
            }
            column(ErpxAmountreceivedHT; "Erpx Amount received HT")
            {
            }
            column(ErpxBenefitForecast; "Erpx Benefit Forecast")
            {
            }
            column(ErpxDesiredBenefitHT; "Erpx Desired Benefit HT")
            {
            }
            column(ErpxNoofOrders; "Erpx No. of Orders")
            {
            }
            column(ErpxNumberofopeninvoices; "Erpx Number of open invoices")
            {
            }
            column(ErpxTotalamountofordersHT; "Erpx Total amount of orders HT")
            {
            }
            column(ErpxFeesHTBalanceAvailable; "Erpx Fees HT Balance Available")
            {
            }
            column(ErpxFeesHTUsed; "Erpx Fees HT Used")
            {
            }
            column(ErpxFeesHTatDisposal; "Erpx Fees HT at Disposal")
            {
            }
            column(ErpxFeeAmountHT; "Erpx Fee Amount HT")
            {
            }
            column(ErpxAverageFees; "Erpx Average Fees")
            {
            }
            column(ErpxHourly_Job; "Erpx % Hourly")
            {
            }
            column(ErpxFeesHT_Job; "Erpx % Fees HT")
            {
            }
            column(ErpxBenefitForecast_Job; "Erpx % Benefit Forecast")
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        ShowDASA := false;
        ShowDoutaz := false;
        if CompanyName = 'Doutaz SA' then
            ShowDoutaz := true;
        if CompanyName = 'DASA' then
            ShowDASA := true;
        if (ShowDASA = false) and (ShowDoutaz = false) then
            ShowDoutaz := true;
    end;

    var
        CompanyInfo: Record "Company Information";
        ShowDASA: Boolean;
        ShowDoutaz: Boolean;
}
