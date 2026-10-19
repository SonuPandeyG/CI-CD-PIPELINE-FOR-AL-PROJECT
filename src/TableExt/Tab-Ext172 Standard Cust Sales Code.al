//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 STARTS <<
tableextension 60016 "Std Cust Sales Code Ext" extends "Standard Customer Sales Code"
{
    fields
    {
        field(50100; "Invoice Frequency"; Enum "Recurring Invoice Frequency")
        {
            Caption = 'Invoice Frequency';
            DataClassification = CustomerContent;
        }

        field(50101; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Next Invoice Due On" = 0D then
                    "Next Invoice Due On" := "Starting Date";
            end;
        }

        field(50102; "Next Invoice Due On"; Date)
        {
            Caption = 'Next Invoice Due On';
            DataClassification = CustomerContent;
        }

        field(50103; "Cust. PO"; Code[35])
        {
            Caption = 'Cust. PO';
            DataClassification = CustomerContent;
        }

        field(50104; "Your Reference No."; Text[35])
        {
            Caption = 'Your Reference No.';
            DataClassification = CustomerContent;
        }

        field(50105; "No. of Invoice Unposted"; Integer)
        {
            Caption = 'No. of Invoice Unposted';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where(
                "Document Type" = const(Invoice),
                "Sell-to Customer No." = field("Customer No."),
                "External Document No." = field("Cust. PO"),
                "Your Reference" = field("Your Reference No.")));
            Editable = false;
        }

        field(50106; "No. of Invoice Posted"; Integer)
        {
            Caption = 'No. of Invoice Posted';
            FieldClass = FlowField;
            CalcFormula = count("Sales Invoice Header" where(
                "Sell-to Customer No." = field("Customer No."),
                "External Document No." = field("Cust. PO"),
                "Your Reference" = field("Your Reference No.")));
            Editable = false;
        }
    }
}
//GTRTeK_SONU Recurring Sales Invoice Automation 13102026 ENDS >>