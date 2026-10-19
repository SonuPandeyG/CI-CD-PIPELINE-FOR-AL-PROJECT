//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 STARTS <<
codeunit 60005 "Auto Create Recurr Sales Inv"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CreateDueInvoices();
    end;

    local procedure CreateDueInvoices()
    var
        StdCustSalesCode: Record "Standard Customer Sales Code";
        RunDate: Date;
    begin
        RunDate := WorkDate();

        StdCustSalesCode.SetFilter("Next Invoice Due On", '%1', RunDate);
        if StdCustSalesCode.FindSet() then
            repeat
                if CanCreateInvoice(StdCustSalesCode) then begin

                    StdCustSalesCode.CreateSalesInvoice(RunDate, RunDate);
                    // Advance only after processing succeeds.
                    UpdateNextInvoiceDate(StdCustSalesCode);
                end;
            until StdCustSalesCode.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Standard Customer Sales Code",
            'OnCreateSalesInvoiceOnBeforeSalesHeaderModify', '', false, false)]
    local procedure OnCreateSalesInvoiceOnBeforeSalesHeaderModify(
            var SalesHeader: Record "Sales Header";
            StandardCustomerSalesCode: Record "Standard Customer Sales Code")
    begin
        SalesHeader.Validate("External Document No.", StandardCustomerSalesCode."Cust. PO");
        SalesHeader.Validate("Your Reference", StandardCustomerSalesCode."Your Reference No.");
    end;

    local procedure CanCreateInvoice(
        StdCustSalesCode: Record "Standard Customer Sales Code"): Boolean
    begin
        if StdCustSalesCode."Next Invoice Due On" = 0D then
            exit(false);

        if StdCustSalesCode.Blocked then
            exit(false);

        // Check validity start date, if specified.
        if (StdCustSalesCode."Valid From Date" <> 0D) and
           (StdCustSalesCode."Next Invoice Due On" < StdCustSalesCode."Valid From Date") then
            exit(false);

        // Check validity end date, if specified.
        if (StdCustSalesCode."Valid To Date" <> 0D) and
           (StdCustSalesCode."Next Invoice Due On" > StdCustSalesCode."Valid To Date") then
            exit(false);

        if StdCustSalesCode."Insert Rec. Lines On Invoices" <> StdCustSalesCode."Insert Rec. Lines On Invoices"::Automatic then
            exit(false);
        exit(true);
    end;

    local procedure UpdateNextInvoiceDate(
        var StdCustSalesCode: Record "Standard Customer Sales Code")
    begin
        case StdCustSalesCode."Invoice Frequency" of
            StdCustSalesCode."Invoice Frequency"::Weekly:
                StdCustSalesCode."Next Invoice Due On" :=
                    CalcDate(
                        '<+1W>',
                        StdCustSalesCode."Next Invoice Due On");

            StdCustSalesCode."Invoice Frequency"::Monthly:
                StdCustSalesCode."Next Invoice Due On" :=
                    CalcDate(
                        '<+1M>',
                        StdCustSalesCode."Next Invoice Due On");

            StdCustSalesCode."Invoice Frequency"::Quarterly:
                StdCustSalesCode."Next Invoice Due On" :=
                    CalcDate(
                        '<+3M>',
                        StdCustSalesCode."Next Invoice Due On");

            StdCustSalesCode."Invoice Frequency"::"Half Yearly":
                StdCustSalesCode."Next Invoice Due On" :=
                    CalcDate(
                        '<+6M>',
                        StdCustSalesCode."Next Invoice Due On");

            StdCustSalesCode."Invoice Frequency"::Yearly:
                StdCustSalesCode."Next Invoice Due On" :=
                    CalcDate(
                        '<+1Y>',
                        StdCustSalesCode."Next Invoice Due On");
        end;

        StdCustSalesCode.Modify(true);
    end;
}
//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 ENDS >>