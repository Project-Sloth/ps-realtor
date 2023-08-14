export interface ITab {
    name: string;
    icon: string;
    component: any;
}

type coords = {
    x: number;
    y: number;
    z: number;
}

interface door extends coords {
    h: number;
    length: number;
    width: number;
    locked?: boolean;
}

type img = {
    url: string;
    label: string;
}

export interface IProperty {
    property_id: number;
    label?: string;
    owner?: string;
    street?: string;
    region?: string;
    description: string;
    shell: string;
    extra_imgs: img[];
    for_sale: number | boolean;
    price: number;
    door_data: door;
    garage_data: coords | null;
    apartment: string;
}

export interface IApartment {
    apartmentData: {
        label: string;
        door: door;
        imgs: img[];
    }
    apartments: string[];
}
