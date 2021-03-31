#!/usr/bin/env python
import re
import sys
from bs4 import BeautifulSoup

PREFIX_ORDERING = ['C','D','FB','J','CONN','Q','R','U','X','SW']
line_number = 1  # globals are awesome

def extract_field(fields, field_name, refdes, opt=False):
    if fields is None:
        print("no fields defined for component {0}".format(refdes))
        return
    matches = fields.findAll('field', { 'name' : field_name })
    if len(matches) != 1:
        if opt:
            return ""
        print("couldn't find required field '{0}' in component {1}".format(field_name, refdes))
        return "unknown"
    return matches[0].next

def extract_refdes_number(refdes):
    return int(re.findall(r'[A-Z]+|\d+',refdes)[1])

def extract_refdes_designator(refdes):
    return re.findall(r'[A-Z]+|\d+',refdes)[0]

def matches_prefix(refdes, prefix):
    if refdes.startswith(prefix) and \
            refdes > len(prefix) and \
            refdes[len(prefix)].isdigit():
        return True
    else:
        return False

def write_components(output_file, components_dict, prefix):
    global line_number
    line_items = []
    for refdes, tag in components_dict.iteritems():
        if matches_prefix(refdes, prefix):
            mpn = extract_field(tag.fields, 'MPN', refdes)
            mfn = extract_field(tag.fields, 'MFN', refdes)
            value = tag.value.next
            if tag.footprint is not None:
                footprint = tag.footprint.next
            else:
                footprint = 'undefined'
            subst = extract_field(tag.fields, 'Substitution OK?', refdes, opt=True)
            voltage = extract_field(tag.fields, 'voltage', refdes, opt=True)
            thermal = extract_field(tag.fields, 'thermal', refdes, opt=True)
            tolerance = extract_field(tag.fields, 'tolerance', refdes, opt=True)
            # see if something exactly like this already exists
            found = False
            des = extract_refdes_designator(refdes)
            for item in line_items:
                if extract_refdes_designator(item['refdes'][0]) == des and \
                   item['mfn'] == mfn and item['mpn'] == mpn:
                    item['refdes'].append(refdes)
                    found = True
                    break
            if not found:
                line_items.append({
                    'refdes':[refdes], 'footprint':footprint,
                    'mpn': mpn, 'mfn': mfn,
                    'value': value, 'tolerance': tolerance, 'thermal': thermal,
                    'voltage': voltage, 'subst': subst})
    # sort within each line item
    for item in line_items:
        item['refdes'].sort(key = lambda x: extract_refdes_number(x))
    # sort based on first item of each line
    line_items.sort(key = lambda x: extract_refdes_number(x['refdes'][0]))
    # now print it all out to CSV
    for item in line_items:
        ref = '"' + ','.join(item['refdes']) + '"'
        qty = str(ref.count(',') + 1)
        mfn = item['mfn']
        mpn = item['mpn']
        value = item['value']
        footprint = item['footprint']
        tolerance = item['tolerance']
        voltage = item['voltage']
        thermal = item['thermal']
        subst = item['subst']
        if mpn == 'DNP':
            footprint = 'DNP'
            value = 'DNP'
        line = ','.join([str(line_number),qty,ref,footprint,value,mfn,mpn])
        output_file.write(line + '\n')
        line_number += 1

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('usage: osrc_bom.py EESCHEMA_XML_FILE')
        sys.exit(1)
    xml_fn = sys.argv[1]
    print('now I will load {0}'.format(xml_fn))
    soup = BeautifulSoup(open(xml_fn), 'lxml')  # todo: catch errors
    out_fn = 'bom.csv'  # todo: be more sophisticated
    with open(out_fn, 'w') as of:
        of.write("# Bill of Materials for '{0}' rev.{1}\n".format(
            soup.design.sheet.title_block.title.contents[0],
            soup.design.sheet.title_block.rev.contents[0]))
        of.write("# Schematic date: {0}\n".format(soup.design.date.contents[0]))
        of.write("Line Item,Quantity,Designator,Footprint,Value,Manufacturer,Manufacturer Part Number\n")
        components = { }
        for c in soup.components.find_all("comp"):
            components[c['ref']] = c
            # make sure it's a prefix we know about
            matched_prefix = False
            for prefix in PREFIX_ORDERING:
                if matches_prefix(c['ref'], prefix):
                    matched_prefix = True
            if not matched_prefix:
                print("ignoring refdes prefix: '{0}'".format(c['ref']))
        # now print them all to the output file
        for prefix in PREFIX_ORDERING:
            write_components(of, components, prefix)
