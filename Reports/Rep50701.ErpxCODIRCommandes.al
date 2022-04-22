report 50701 "Erpx CODIR Commandes"
{
    Caption = 'Erpx CODIR Commandes';
    RDLCLayout = './Reports/CODIRCommandes.rdl';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(No; "No.")
            { }
            column(ShowDoutaz; ShowDoutaz)
            { }
            column(ShowDASA; ShowDASA)
            { }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(ErpXJobNo_SalesHeader; "ErpX Job No.")
            {
            }
            column(ErpxJobCity_SalesHeader; "Erpx Job City")
            {
            }
            column(Abbreviation_SalesHeader; Abbreviation)
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sell-to Customer Name")
            {
            }
            column(ErpxDocumentType_SalesHeader; "Erpx Document Type")
            {
            }
            column(ErpxTotalAmountHT_SalesHeader; "Erpx Total Amount HT")
            {
            }
            column(ErpxTotalAmountInvoicedHT_SalesHeader; "Erpx Total Amount Invoiced HT")
            {
            }
            column(ErpxInvoiced_SalesHeader; "Erpx % Invoiced")
            {
            }
            column(ErpxBalanceHT_SalesHeader; "Erpx Balance HT")
            {
            }
            column(ErpxOtherFees_SalesHeader; "Erpx Other Fees")
            {
            }
            column(ErpxFeeAmountHT_SalesHeader; "Erpx Fee Amount HT")
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
