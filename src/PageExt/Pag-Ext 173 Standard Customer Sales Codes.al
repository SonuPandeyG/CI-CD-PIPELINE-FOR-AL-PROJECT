//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 STARTS <<
pageextension 60023 "Std Cust Sales Code Page Ext" extends "Standard Customer Sales Codes"
{
    layout
    {
        addafter("Valid To Date")
        {

            field("Invoice Frequency"; Rec."Invoice Frequency")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the recurring invoice frequency.';
            }

            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the starting date for recurring invoices.';
            }

            field("Next Invoice Due On"; Rec."Next Invoice Due On")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the next scheduled invoice date.';
                Editable = false;
            }

            field("Cust. PO"; Rec."Cust. PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer purchase order number to copy to the sales invoice.';
            }

            field("Your Reference No."; Rec."Your Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Your Reference value to copy to the sales invoice.';
            }

            field("No. of Invoice Unposted"; Rec."No. of Invoice Unposted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of matching unposted sales invoices.';
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                    SalesHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
                    SalesHeader.SetRange("External Document No.", Rec."Cust. PO");
                    SalesHeader.SetRange("Your Reference", Rec."Your Reference No.");
                    Page.Run(Page::"Sales Invoice List", SalesHeader);
                end;
            }

            field("No. of Invoice Posted"; Rec."No. of Invoice Posted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of matching posted sales invoices.';
                Editable = false;
                DrillDown = true;
            }

        }
    }
}
//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 ENDS >>